---
title: "plan"
output: html_document
---

Scraper for events happening around Amsterdam. R pkg intented to provide functionality for:  

- scraping of data from various sources
- cleaning up and enrich the data
- store away in a db
- some analysis tools as well as a jab at a predictive model
- visualisation tools  

# To do

- ~~dump each days data into monetdb~~  
- ~~parse datetime data into nicer format, separate features~~
- ~~spatial visualisation prototype~~
- ~~refactor code, funs in separate files~~
- ~~add distance to Rembrandtplein as feature to each event (obs)~~
- ~~partyflock scraper~~
- ~~fake facebook account scraper~~
- ~~get coordinates of all locations in amsterdam~~

- set unified data model
- change window of pulled data and increase number of pulled events
- make all funs that call apis more safe (safely ...)
- tests, especially the scraping stuff
- write docs

- check out role model pkgs for web api's testing (googledrive, osmdata)
- consider switching to crul pkg for async requests



# Ideas

- spatio-temporal event analysis 
  - clustering of highly-popular events in certain area
  - data mining of temporal patterns e.g. 1st Saturday of each month very
  busy
- pull only results from simfuny that are _actually_ within
  the range of Rembrandtplein (filter out stuff in Paradiso etc.)

- [related events](http://api.simfuny.com/app/api/2_0/event?callback=__ng_jsonp__.__req1.finished&nid=127311)
- [same host events](http://api.simfuny.com/app/api/2_0/events/host?callback=__ng_jsonp__.__req1.finished&hostid=50501&eventid=127311)
