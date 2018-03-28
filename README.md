R package and app that got bourne out of the ideas from the "Managing Crowds" hackathon at the Gemeente Amsterdam. This is basically a scraper for events happening around Amsterdam with extended functionality for:

-   scraping of data from various sources ()
-   cleaning up and enrichment of data
-   persistent storage in local database
-   some analysis tools as well as a jab at a predictive model
-   visualisation tools

Sample outputs
--------------

-   Sample [simfuny](http://simfuny.com/) data

| title                                                           |     nid| img                                                                                                             | location           |       lat|      long|  secret|  attending| event\_link                                                                                     | fb\_link                                           |  fb\_going|  fb\_interested| date\_wday | date2\_wday | date\_conv | date2\_conv | sold\_out | timestamp           |  dist\_rembrandtplein| near\_rembrandtplein |
|:----------------------------------------------------------------|-------:|:----------------------------------------------------------------------------------------------------------------|:-------------------|---------:|---------:|-------:|----------:|:------------------------------------------------------------------------------------------------|:---------------------------------------------------|----------:|---------------:|:-----------|:------------|:-----------|:------------|:----------|:--------------------|---------------------:|:---------------------|
| Solstice Festival 2017                                          |   66989| <http://api.simfuny.com/sites/default/files/photo/events/15895656_1272531012786388_5048735231400931615_o_0.jpg> | Ruigoord 76        |  52.44437|  4.828969|       0|       1706| <http://simfuny.com/event/66989/solstice-festival-2017>                                         | <https://www.facebook.com/events/604130049795847>  |       1600|            6200| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             9468.8851| FALSE                |
| Official After Party Awakenings Festival - Saturday (SOLD OUT)  |  111393| <http://api.simfuny.com/sites/default/files/photo/events/19113915_1252454411543704_9161799471844597684_n_0.jpg> | Paradiso Amsterdam |  52.36228|  4.883950|       0|        591| <http://simfuny.com/event/111393/official-after-party-awakenings-festival-saturday-sold-out>    | <https://www.facebook.com/events/1493465287363922> |        631|             894| Sat        | Sun         | 2017-06-24 | 2017-06-25  | TRUE      | 2017-06-25 01:03:48 |              546.4308| FALSE                |
| Last minute: Vunzige Deuntjes At The Beach - Whoosah            |  113285| <http://api.simfuny.com/sites/default/files/photo/events/19247802_1385427731576751_8025315936222131220_n.jpg>   | Whoosah Beachclub  |  52.12114|  4.292650|       0|        389| <http://simfuny.com/event/113285/last-minute-vunzige-deuntjes-at-the-beach-whoosah>             | <https://www.facebook.com/events/1345309678917690> |        558|            1400| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |            48972.4771| FALSE                |
| BLAST DEM BEATZ, Amsterdam                                      |   90417| <http://api.simfuny.com/sites/default/files/photo/events/17880015_1430787306971389_8614946080905047345_o_0.jpg> | AIR Amsterdam      |  52.36611|  4.899450|       0|        367| <http://simfuny.com/event/90417/blast-dem-beatz-amsterdam>                                      | <https://www.facebook.com/events/385583831803951>  |         NA|              NA| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |                0.0000| TRUE                 |
| Froluck Festival                                                |   94883| <http://api.simfuny.com/sites/default/files/photo/events/17917179_1401647759858361_4885522083845619718_o_0.jpg> | Amsterdam Roest    |  52.37205|  4.926681|       0|        257| <http://simfuny.com/event/94883/froluck-festival>                                               | <https://www.facebook.com/events/283737608748138>  |        274|            1200| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             1901.2165| FALSE                |
| DeepHouse Injection Local Heroes                                |  108963| <http://api.simfuny.com/sites/default/files/photo/events/18559008_465583720457823_2885231499379063110_o_0.jpg>  | VLLA               |  52.36349|  4.835000|       0|        210| <http://simfuny.com/event/108963/deephouse-injection-local-heroes>                              | <https://www.facebook.com/events/1279193918865678> |         NA|              NA| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             3595.9747| FALSE                |
| Playground - Girls Love DJ's, Geza Weisz & more - AIR Amsterdam |  111199| <http://api.simfuny.com/sites/default/files/photo/events/19144061_451265761906465_700762667113866850_o.jpg>     | AIR Amsterdam      |  52.36624|  4.899008|       0|        203| <http://simfuny.com/event/111199/playground-girls-love-dj-s-geza-weisz-more-air-amsterdam>      | <https://www.facebook.com/events/789674351195661>  |        228|             238| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |                0.0000| TRUE                 |
| 1 jaar Ondersteboven                                            |  100699| <http://api.simfuny.com/sites/default/files/photo/events/18238868_1907959472756120_8077760870680434805_o.jpg>   | Canvas             |  52.35378|  4.911940|       0|        198| <http://simfuny.com/event/100699/1-jaar-ondersteboven>                                          | <https://www.facebook.com/events/305547306526066>  |        220|             295| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             1508.7648| FALSE                |
| JIGGY x Neptunes vs Timbaland x Zaterdag 24 juni x Bitterzoet   |  107705| <http://api.simfuny.com/sites/default/files/photo/events/18738979_1128781487227168_1607161927095219609_o.jpg>   | Bitterzoet         |  52.37736|  4.894140|       0|        196| <http://simfuny.com/event/107705/jiggy-x-neptunes-vs-timbaland-x-zaterdag-24-juni-x-bitterzoet> | <https://www.facebook.com/events/435366913505455>  |        229|             463| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             1105.5562| FALSE                |
| VBX Summerseries w/ Lamache, Makcim, Reiss, Herra + more tba    |  104983| <http://api.simfuny.com/sites/default/files/photo/events/18559012_1544341288940388_255380710848693236_o_0.jpg>  | BRET               |  52.38997|  4.836817|       0|        184| <http://simfuny.com/event/104983/vbx-summerseries-w-lamache-makcim-reiss-herra-more-tba>        | <https://www.facebook.com/events/262855727516262>  |        291|             540| Sat        | Sun         | 2017-06-24 | 2017-06-25  | FALSE     | 2017-06-25 01:03:48 |             4300.8798| FALSE                |

-   Sample [partyflock](http://partyflock.nl/) data

| event\_name                         |  attending| event\_location | date              | timestamp           |
|:------------------------------------|----------:|:----------------|:------------------|:--------------------|
| 3x NYX                              |        394| NYX             | 16 september 2017 | 2017-09-16 01:22:47 |
| Bongo's Bingo                       |        142| Panama          | 16 september 2017 | 2017-09-16 01:22:47 |
| Claire & Late Night Burners         |        135| Claire          | 16 september 2017 | 2017-09-16 01:22:47 |
| Contact                             |         31| OT301           | 16 september 2017 | 2017-09-16 01:22:47 |
| Curated By Lenzman                  |        674| Paradiso        | 16 september 2017 | 2017-09-16 01:22:47 |
| De Nacht van NieuwLicht             |        432| Ruigoord        | 16 september 2017 | 2017-09-16 01:22:47 |
| De School                           |        504| De School       | 16 september 2017 | 2017-09-16 01:22:47 |
| Encore · Red Bull 3Style Afterparty |         20| Melkweg         | 16 september 2017 | 2017-09-16 01:22:47 |
| Filth On Acid                       |        331| De Marktkantine | 16 september 2017 | 2017-09-16 01:22:47 |
| Fuego · Back to Old School          |        169| Bitterzoet      | 16 september 2017 | 2017-09-16 01:22:47 |

-   Sample map outpus (very rough sketch)

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
