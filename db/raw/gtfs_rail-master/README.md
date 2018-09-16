# Los Angeles County Metropolitan Transportation Authority's GTFS for Rail.
## updated 2018-09-15 01:00:16 PDT America/Los_Angeles

As of May 6th, 2016 The LACMTA is now publishing our Bus and Rail Services in separate Google Transit Exports ONLY. As a customer service, and to allow us to update these files more frequently, we have split these files up. The new rail-only export will be updated Daily (generally Tuesday-Saturday mornings), to allow us to send out more timely information and to allow our users to capture all temporary rail service changes that may occur on a daily basis. The bus-only exports will continue to be provided as large-scale changes to the system occur -- generally once every one or two months. We will NOT continue to maintain the combined service feeds.

### Join our developer community at [http://developer.metro.net](http://developer.metro.net) to learn more about using this data.

### Link to LACMTA's Bus Data repository: [https://gitlab.com/LACMTA/gtfs_bus/](https://gitlab.com/LACMTA/gtfs_bus/)

---

### Evergreen link to the gtfs_rail.zip archive: [https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip](https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?1536998416.62)

### Today's link to the gtfs_rail.zip archive: [https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?1536998416.62](https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?1536998416.62)


### zip archive contents
```
 Length   Creation datetime         Name        
-----------------------------------------------
     173  2018-09-15 00:21   agency.txt         
    2140  2018-09-15 00:21   calendar.txt       
     464  2018-09-15 00:21   calendar_dates.txt 
     642  2018-09-15 00:21   routes.txt         
  273495  2016-03-16 16:09   shapes.txt         
   33465  2017-02-08 15:08   stops.txt          
14134269  2018-09-15 00:22   stop_times.txt     
  691960  2018-09-15 00:21   trips.txt          
     283  2018-09-14 01:00   feed_info.txt      
```

## Summary of changes
```
commit cc52e56f10c720b17613651b9bcb3bea1c77ce4f
Author: metrodgoodwin <dgoodwin@gmail.com>
Date:   Fri Sep 14 01:00:07 2018 -0700

    2018-09-14 01:00:03 PDT America/Los_Angeles

 README.md          |    39 +-
 calendar.txt       |    37 +-
 calendar_dates.txt |    15 +-
 gtfs_rail.zip      |   Bin 1246557 -> 1345359 bytes
 stop_times.txt     | 78678 ++++++++++++++++++++++++++++++---------------------
 trips.txt          |  4378 ++-
 6 files changed, 49823 insertions(+), 33324 deletions(-)
```

## Subscribing to changes

### Get the latest commit ID with Curl

```
#!/bin/sh

url="https://gitlab.com/LACMTA/gtfs_rail/commits/master.atom"

curl --silent "$url" | grep -E '(title>|updated>)' | \
  sed -n '4,$p' | \
  sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<updated>/   /' \
      -e 's/<\/updated>//' | \
  head -2 | fmt

# returns:
# 2015-12-31T13:09:36Z
#    new info from SPA and instructions on preparing the archive
```

### Get the latest commit ID with Python

```
#!/bin/env python

import feedparser

url = 'https://gitlab.com/LACMTA/gtfs_rail/commits/master.atom'
d = feedparser.parse(url)
lastupdate = d['feed']['updated']

print(lastupdate)

```

See the [http://developer.metro.net/the-basics/policies/terms-and-conditions/](http://developer.metro.net/the-basics/policies/terms-and-conditions/) page for terms and conditions.
