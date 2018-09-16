# Los Angeles County Metropolitan Transportation Authority's GTFS for Rail.
## updated $thetimestamp

As of May 6th, 2016 The LACMTA is now publishing our Bus and Rail Services in separate Google Transit Exports ONLY. As a customer service, and to allow us to update these files more frequently, we have split these files up. The new rail-only export will be updated Daily (generally Tuesday-Saturday mornings), to allow us to send out more timely information and to allow our users to capture all temporary rail service changes that may occur on a daily basis. The bus-only exports will continue to be provided as large-scale changes to the system occur -- generally once every one or two months. We will NOT continue to maintain the combined service feeds.

### Join our developer community at [http://developer.metro.net](http://developer.metro.net) to learn more about using this data.

### Link to LACMTA's Bus Data repository: [https://gitlab.com/LACMTA/gtfs_bus/](https://gitlab.com/LACMTA/gtfs_bus/)

---

### Evergreen link to the gtfs_rail.zip archive: [https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip](https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?$ts)

### Today's link to the gtfs_rail.zip archive: [https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?$ts](https://gitlab.com/LACMTA/gtfs_rail/raw/master/gtfs_rail.zip?$ts)


### zip archive contents
```
$thefiletable
```

## Summary of changes
```
$thegitlog
```

## Subscribing to changes

### Get the latest commit ID with Curl

```
#!/bin/sh

url="https://gitlab.com/LACMTA/gtfs_rail/commits/master.atom"

curl --silent "$$url" | grep -E '(title>|updated>)' | \
  sed -n '4,$$p' | \
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
