from ftplib import FTP
import sys, shutil, time
from os import stat
from string import Template
from datetime import datetime
import git
import pytz
from zipfile import ZipFile
from texttable import Texttable
import pandas as pd

from myconfig import ftp_server, ftp_user, ftp_pass, remotepath, DEBUG, repodir

# this script grabs Metro's latest GTFS archive for Nextrail,
# unpacks the archive and builds a README.md file.
# it then unpacks the files, commits them into the repository
# and pushes the changes to https://gitlab.com/LACMTA/gtfs_rail

myoutf="gtfs_rail.zip"
r = git.Repo(repodir)

ftp = FTP(ftp_server)
ftp.login(ftp_user, ftp_pass)

def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

def updateTerminalPickups(stoptimesfile='stop_times.txt',DEBUG=False):
    stop_times = stoptimesfile
    fieldnames = ['trip_id','arrival_time','departure_time','stop_id','stop_sequence','stop_headsign','pickup_type','drop_off_type']
    # create a dataframe from the stop_times_sorted.txt file
    df = pd.read_csv(stop_times, usecols=fieldnames)
    # Let's set the `pickup_type` column to 1 (indicating no pickup) on the last stop for every trip
    df.loc[ df.groupby(['trip_id'], sort=False)['stop_sequence'].transform('idxmax'),'pickup_type' ]=1
    # create the new csv
    df.to_csv('stop_times.csv', columns=fieldnames, index=False, header=True)
    # update the file
    if (int( file_len('stop_times.csv') ) == int( file_len(stoptimesfile) )):
        if DEBUG:
            print('done!')
        shutil.move('stop_times.csv', stoptimesfile)
    else:
        print('file length different')

def writeREADME(tpl='README.tpl', outfile='README.md', thevars={ 'thefiletable':'', 'thetimestamp':'', 'thegitlog':'', 'ts':'' }):
    #open the template file
    template_file = open( tpl )
    src = Template( template_file.read() )
    #do the substitution
    README = src.substitute(thevars)

    f = open(outfile,"w")
    f.write( README )
    f.close()

def writeFEEDINFO(tpl='feed_info.tpl', outfile='feed_info.txt', thevars={}):
    #open the template file
    template_file = open( tpl )
    src = Template( template_file.read() )
    #do the substitution
    FEEDINFO = src.substitute(thevars)

    f = open(outfile,"w")
    f.write( FEEDINFO )
    f.close()

def dos2unix(afile,DEBUG=False):
    content = ''
    outsize = 0
    with open(afile, 'rb') as infile:
        content = infile.read()
    infile.close()
    with open(afile, 'wb') as outfile:
        for line in content.splitlines():
            outsize += len(line) + 1
            outfile.write(line + b'\n')
    outfile.close()
    if DEBUG:
        print("Done. Stripped %s bytes." % (len(content)-outsize))

def getbinary(ftp, remotedir="/", remotef="hi.zip", outfile=None):
    # fetch a binary file
    ftp.cwd(remotedir)
    if outfile is None:
        outfile = sys.stdout
    else:
        with open(outfile, 'wb') as f:
            ftp.retrbinary("RETR " + remotef, f.write)

resp = getbinary(ftp, remotedir=remotepath, remotef="GTFS_Rail_Nextrain.zip", outfile="gtfs_rail.zip")
if DEBUG: print( "ftp server reponse: %s" %(resp))
ftp.quit()

# add the feed_info.txt file
zf = ZipFile(myoutf, mode='a')
try:
    zf.write('feed_info.txt')
finally:
    zf.close()

# let's work with the zip file
zobj = ZipFile(myoutf)
stats = stat(myoutf)
dt = datetime.fromtimestamp(stats.st_ctime)

tzstr = "America/Los_Angeles"
fmt = '%Y-%m-%d %H:%M:%S %Z'
dt = datetime.now(pytz.timezone(tzstr))
version = dt.strftime(fmt) + ' ' + tzstr
ts = time.time()

# unzip the contents
zobj.extractall()

# fix the pickup codes
updateTerminalPickups(stoptimesfile='stop_times.txt',DEBUG=DEBUG)

# let's update the README.md file
flist = zobj.namelist()

table = Texttable()
# horizontal lines, vertical lines, intersection points of these lines, and the header line
table.set_chars(['','','','-'])
table.set_deco(table.HEADER | table.VLINES)
table.set_cols_align(["r", "c", "l"])
tablelist = []
tablelist.append(["Length", "Creation datetime", "Name"])

writeFEEDINFO(tpl='feed_info.tpl', outfile='feed_info.txt', thevars={})

print(flist)

# get the contents and add the files to the commit list
for fi in flist:
    dos2unix(fi,DEBUG)
    r.index.add([fi])
    dtup = zobj.getinfo(fi).date_time
    dtstr = "%d-%02d-%02d %02d:%02d" %(dtup[0],dtup[1],dtup[2],dtup[3],dtup[4])
    thisrow = [zobj.getinfo(fi).file_size, dtstr, fi]
    tablelist.append(thisrow)

table.add_rows(tablelist)
thefiletable = table.draw()
if DEBUG: print(thefiletable)

# git log -1  --stat
thegitlog = r.git.log('-1', '--stat')

tplvars = {
    'thefiletable':thefiletable,
    'thetimestamp':version,
    'thegitlog':thegitlog,
    'ts':ts,
    }

writeREADME(tpl='README.tpl', outfile='README.md', thevars=tplvars)

# did more than one file (the README.md) change?
files_changed=r.git.diff('--name-only')
if (".zip" in files_changed):
    # add the README.md file to the commit list
    r.index.add(["README.md"])
    r.index.add(["feed_info.txt"])

    # add the original ZIPFILE file to the commit list
    r.index.add([myoutf])

    # commit all the changes
    r.index.commit(version)

    #pull and push
    origin = r.remotes.origin
    pullinfo = origin.pull()
    # if DEBUG: print (pullinfo)
    pushinfo = origin.push()
    if DEBUG: print (pushinfo)
