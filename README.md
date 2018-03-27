R package and app that got bourne out of the ideas from the "Managing Crowds" hackathon at the Gemeente Amsterdam. This is basically a scraper for events happening around Amsterdam with extended functionality for:

-   scraping of data from various sources ()
-   cleaning up and enrichment of data
-   persistent storage in local database
-   some analysis tools as well as a jab at a predictive model
-   visualisation tools

Sample outputs
--------------

-   Sample [simfuny](http://simfuny.com/) data

<!-- -->

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   nid = col_integer(),
    ##   lat = col_double(),
    ##   long = col_double(),
    ##   secret = col_integer(),
    ##   attending = col_integer(),
    ##   fb_going = col_integer(),
    ##   fb_interested = col_integer(),
    ##   date_conv = col_date(format = ""),
    ##   date2_conv = col_date(format = ""),
    ##   sold_out = col_logical(),
    ##   timestamp = col_datetime(format = ""),
    ##   dist_rembrandtplein = col_double(),
    ##   near_rembrandtplein = col_logical()
    ## )

    ## See spec(...) for full column specifications.

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-aa13f68c4c45b55cf35d">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10"],["Solstice Festival 2017","Official After Party Awakenings Festival - Saturday (SOLD OUT)","Last minute: Vunzige Deuntjes At The Beach - Whoosah","BLAST DEM BEATZ, Amsterdam","Froluck Festival","DeepHouse Injection Local Heroes","Playground - Girls Love DJ's, Geza Weisz &amp; more - AIR Amsterdam","1 jaar Ondersteboven","JIGGY x Neptunes vs Timbaland x Zaterdag 24 juni x Bitterzoet","VBX Summerseries w/ Lamache, Makcim, Reiss, Herra + more tba"],[66989,111393,113285,90417,94883,108963,111199,100699,107705,104983],["http://api.simfuny.com/sites/default/files/photo/events/15895656_1272531012786388_5048735231400931615_o_0.jpg","http://api.simfuny.com/sites/default/files/photo/events/19113915_1252454411543704_9161799471844597684_n_0.jpg","http://api.simfuny.com/sites/default/files/photo/events/19247802_1385427731576751_8025315936222131220_n.jpg","http://api.simfuny.com/sites/default/files/photo/events/17880015_1430787306971389_8614946080905047345_o_0.jpg","http://api.simfuny.com/sites/default/files/photo/events/17917179_1401647759858361_4885522083845619718_o_0.jpg","http://api.simfuny.com/sites/default/files/photo/events/18559008_465583720457823_2885231499379063110_o_0.jpg","http://api.simfuny.com/sites/default/files/photo/events/19144061_451265761906465_700762667113866850_o.jpg","http://api.simfuny.com/sites/default/files/photo/events/18238868_1907959472756120_8077760870680434805_o.jpg","http://api.simfuny.com/sites/default/files/photo/events/18738979_1128781487227168_1607161927095219609_o.jpg","http://api.simfuny.com/sites/default/files/photo/events/18559012_1544341288940388_255380710848693236_o_0.jpg"],["Ruigoord 76","Paradiso Amsterdam","Whoosah Beachclub","AIR Amsterdam","Amsterdam Roest","VLLA","AIR Amsterdam","Canvas","Bitterzoet","BRET"],[52.44436753,52.36228,52.121140120608,52.36611,52.372049060304,52.36349,52.366242406087,52.35378,52.37736,52.389967027416],[4.82896868,4.8839499,4.2926500484975,4.89945,4.9266815185547,4.835,4.8990085489949,4.91194,4.89414,4.8368167877197],[0,0,0,0,0,0,0,0,0,0],[1706,591,389,367,257,210,203,198,196,184],["http://simfuny.com/event/66989/solstice-festival-2017","http://simfuny.com/event/111393/official-after-party-awakenings-festival-saturday-sold-out","http://simfuny.com/event/113285/last-minute-vunzige-deuntjes-at-the-beach-whoosah","http://simfuny.com/event/90417/blast-dem-beatz-amsterdam","http://simfuny.com/event/94883/froluck-festival","http://simfuny.com/event/108963/deephouse-injection-local-heroes","http://simfuny.com/event/111199/playground-girls-love-dj-s-geza-weisz-more-air-amsterdam","http://simfuny.com/event/100699/1-jaar-ondersteboven","http://simfuny.com/event/107705/jiggy-x-neptunes-vs-timbaland-x-zaterdag-24-juni-x-bitterzoet","http://simfuny.com/event/104983/vbx-summerseries-w-lamache-makcim-reiss-herra-more-tba"],["https://www.facebook.com/events/604130049795847","https://www.facebook.com/events/1493465287363922","https://www.facebook.com/events/1345309678917690","https://www.facebook.com/events/385583831803951","https://www.facebook.com/events/283737608748138","https://www.facebook.com/events/1279193918865678","https://www.facebook.com/events/789674351195661","https://www.facebook.com/events/305547306526066","https://www.facebook.com/events/435366913505455","https://www.facebook.com/events/262855727516262"],[1600,631,558,null,274,null,228,220,229,291],[6200,894,1400,null,1200,null,238,295,463,540],["Sat","Sat","Sat","Sat","Sat","Sat","Sat","Sat","Sat","Sat"],["Sun","Sun","Sun","Sun","Sun","Sun","Sun","Sun","Sun","Sun"],["2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24","2017-06-24"],["2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25","2017-06-25"],[false,true,false,false,false,false,false,false,false,false],["2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z","2017-06-25T01:03:48Z"],[9468.88508684362,546.430777184368,48972.4770786216,0,1901.21654127266,3595.97465741173,0,1508.76480024593,1105.55618684188,4300.87978895628],[false,false,false,true,false,false,true,false,false,false]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>title<\/th>\n      <th>nid<\/th>\n      <th>img<\/th>\n      <th>location<\/th>\n      <th>lat<\/th>\n      <th>long<\/th>\n      <th>secret<\/th>\n      <th>attending<\/th>\n      <th>event_link<\/th>\n      <th>fb_link<\/th>\n      <th>fb_going<\/th>\n      <th>fb_interested<\/th>\n      <th>date_wday<\/th>\n      <th>date2_wday<\/th>\n      <th>date_conv<\/th>\n      <th>date2_conv<\/th>\n      <th>sold_out<\/th>\n      <th>timestamp<\/th>\n      <th>dist_rembrandtplein<\/th>\n      <th>near_rembrandtplein<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,5,6,7,8,11,12,19]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
-   Sample [partyflock](http://partyflock.nl/) data

<!-- -->

    ## Parsed with column specification:
    ## cols(
    ##   event_name = col_character(),
    ##   attending = col_integer(),
    ##   event_location = col_character(),
    ##   date = col_character(),
    ##   timestamp = col_datetime(format = "")
    ## )

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-4be24cf5bd7380b35668">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10"],["3x NYX","Bongo's Bingo","Claire &amp; Late Night Burners","Contact","Curated By Lenzman","De Nacht van NieuwLicht","De School","Encore · Red Bull 3Style Afterparty","Filth On Acid","Fuego · Back to Old School"],[394,142,135,31,674,432,504,20,331,169],["NYX","Panama","Claire","OT301","Paradiso","Ruigoord","De School","Melkweg","De Marktkantine","Bitterzoet"],["16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017","16 september 2017"],["2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z","2017-09-16T01:22:47Z"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>event_name<\/th>\n      <th>attending<\/th>\n      <th>event_location<\/th>\n      <th>date<\/th>\n      <th>timestamp<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
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
