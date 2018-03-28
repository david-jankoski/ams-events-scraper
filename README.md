R package and app that got bourne out of the ideas from the "Managing Crowds" hackathon at the Gemeente Amsterdam. This is basically a scraper for events happening around Amsterdam with extended functionality for:

-   scraping of data from various sources ()
-   cleaning up and enrichment of data
-   persistent storage in local database
-   some analysis tools as well as a jab at a predictive model
-   visualisation tools

Sample outputs
--------------

-   Sample [simfuny](http://simfuny.com/) data

| title                                                          |     nid| img                                                                                                             | location           |       lat|      long|  secret|  attending| event\_link                                                                                  | fb\_link                                           |  fb\_going|  fb\_interested| date\_wday | date2\_wday | date\_conv | date2\_conv | sold\_out | timestamp           |  dist\_rembrandtplein| near\_rembrandtplein |
|:---------------------------------------------------------------|-------:|:----------------------------------------------------------------------------------------------------------------|:-------------------|---------:|---------:|-------:|----------:|:---------------------------------------------------------------------------------------------|:---------------------------------------------------|----------:|---------------:|:-----------|:------------|:-----------|:------------|:----------|:--------------------|---------------------:|:---------------------|
| Solstice Festival 2017                                         |   66989| <http://api.simfuny.com/sites/default/files/photo/events/15895656_1272531012786388_5048735231400931615_o_0.jpg> | Ruigoord 76        |  52.44437|  4.828969|       0|       1706| <http://simfuny.com/event/66989/solstice-festival-2017>                                      | <https://www.facebook.com/events/604130049795847>  |       1600|            6200| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             9468.8851| FALSE                |
| Official After Party Awakenings Festival - Saturday (SOLD OUT) |  111393| <http://api.simfuny.com/sites/default/files/photo/events/19113915_1252454411543704_9161799471844597684_n_0.jpg> | Paradiso Amsterdam |  52.36228|  4.883950|       0|        591| <http://simfuny.com/event/111393/official-after-party-awakenings-festival-saturday-sold-out> | <https://www.facebook.com/events/1493465287363922> |        631|             894| Sat        | Sun         | 2017-06-24 | 2017-06-25  | TRUE      | 2017-06-25 01:03:48 |              546.4308| FALSE                |
| Last minute: Vunzige Deuntjes At The Beach - Whoosah           |  113285| <http://api.simfuny.com/sites/default/files/photo/events/19247802_1385427731576751_8025315936222131220_n.jpg>   | Whoosah Beachclub  |  52.12114|  4.292650|       0|        389| <http://simfuny.com/event/113285/last-minute-vunzige-deuntjes-at-the-beach-whoosah>          | <https://www.facebook.com/events/1345309678917690> |        558|            1400| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |            48972.4771| FALSE                |

-   Sample [partyflock](http://partyflock.nl/) data

| event\_name                 |  attending| event\_location | date              | timestamp           |
|:----------------------------|----------:|:----------------|:------------------|:--------------------|
| 3x NYX                      |        394| NYX             | 16 september 2017 | 2017-09-16 01:22:47 |
| Bongo's Bingo               |        142| Panama          | 16 september 2017 | 2017-09-16 01:22:47 |
| Claire & Late Night Burners |        135| Claire          | 16 september 2017 | 2017-09-16 01:22:47 |
| Contact                     |         31| OT301           | 16 september 2017 | 2017-09-16 01:22:47 |
| Curated By Lenzman          |        674| Paradiso        | 16 september 2017 | 2017-09-16 01:22:47 |

-   Sample map outputs (very rough sketch)

![](sample_map.png)

TODO
====

-   set unified data model
-   change window of pulled data and increase number of pulled events
-   make all funs that call apis more safe (safely ...)
-   tests, especially the scraping stuff
-   write docs

-   check out role model pkgs for web api's testing (googledrive, osmdata)
-   consider switching to crul pkg for async requests

TADA
====

-   dump each days data into monetdb
-   parse datetime data into nicer format, separate features
-   spatial visualisation prototype
-   refactor code, funs in separate files
-   add distance to Rembrandtplein as feature to each event (obs)
-   partyflock scraper
-   fake facebook account scraper
-   get coordinates of all locations in amsterdam

Ideas
=====

-   spatio-temporal event analysis
-   clustering of highly-popular events in certain area
-   data mining of temporal patterns e.g. 1st Saturday of each month very busy

-   [related events](http://api.simfuny.com/app/api/2_0/event?callback=__ng_jsonp__.__req1.finished&nid=127311)
-   [same host events](http://api.simfuny.com/app/api/2_0/events/host?callback=__ng_jsonp__.__req1.finished&hostid=50501&eventid=127311)
