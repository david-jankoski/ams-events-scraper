
# 0. Pre-requisites -------------
library("jsonlite")
library("glue")
library("tidyverse")

# source needed funs
# TODO make this script fun and pkg everything up
files <- c("R/simfuny_funs.R",
           "R/facebook_funs.R",
           "R/enrich_data_funs.R",
           "R/store_data.R")
invisible(sapply(files, source))

# go to simfuny.com, select date "Deze Week", sort by "Populair" and
# tick the Festival, Nachtleven, Voorstelling
# inspecting the network call it makes - this seems to be the link for
# getting the response for top 25 most popular events this week.
events_url <-
  glue::glue(
    "http://api.simfuny.com/app/api/2_0/events?",
    "callback=__ng_jsonp__.__req1.finished&",
    "offset=0&limit=25&",
    "sort=popular&search=&",
    "types[]=unlabeled&dates[]=week&",
    "startDate=&endDate=&",
    "hosts[]=Festivals&",
    "hosts[]=Nightlife&",
    "hosts[]=Performing Arts&",
    "hosts[]=Uncategorized&hidelongterm=1"
  )

# 1. Collect events data ---------------------

# collect events in dataframe
events <-
  events_url %>%
  # get url content as text
  httr::GET() %>%
  xml2::read_html() %>%
  rvest::html_text() %>%
  # format is a bit strange with this string in front and some
  # pesky brackets - clean up so we can clean import JSON
  #
  # ! REMARK - this might change in future so either test for
  # stability, write tests to detect if it breaks or think of
  # a more robust way to handle this.
  stringr::str_replace(pattern = "__ng_jsonp__.__req1.finished\\(", "") %>%
  stringr::str_sub(end = -3L) %>%
  jsonlite::fromJSON()


# 2. Create event-links -------------------------------
#
# construct the event urls from the titles
events <-
  events %>%
  dplyr::mutate( 
    event_link = purrr::map2_chr( nid, title, create_simfuny_event_link ) 
  )


# 3. Get fb link for each event -------------------

# .3.1 Start Docker  ------
#
# Initialise docker daemon and start the splashr docker image
# Need to find solution for the first one from within R
#
# this should get docker + splash running on 127.0.0.1 port 8050
# sudo dockerd
#
# then this should do the trick
library("splashr")
splashr::start_splash()

# alternative manual method
#sp <- splash(host = "127.0.0.1", port = "8050")

# if all went ok this should return TRUE
# for the alternative manual method :
# stopifnot(splash_active(sp))
stopifnot(splashr::splash_active())

# .3.2 Get Fb link ------
#
# render each simfuny event link html and
# grab the "Meer Info" link leading to
# (most probably) the corresponding fb event link
events <-
  events %>%
  dplyr::mutate(
    fb_link = purrr::map_chr(event_link, create_fb_event_link)
  )

# 4. Get fb attendance -------

# render each fb_link and return the attendance nums
events <-
  events %>%
  dplyr::mutate(
    fb_nums = purrr::map(fb_link, get_fb_attendance),
    fb_going = purrr::map_int(fb_nums, "fb_going"),
    fb_interested = purrr::map_int(fb_nums, "fb_interested")
  )


# 5. Add events metadata -----------------------

# TODO refactor out in separate fun for
# bit cleaner look
events <-
  events %>%
  
  dplyr::mutate_at(
    # select only cols with date in name
    dplyr::vars( contains("date") ),
    # apply helper funs to extract datetime
    # info only on them
    dplyr::funs(wday = get_dates_wday,
                conv = convert_dates
    )
  ) %>%
  
  dplyr::mutate(
    # does simfuny indicate in the title that event is sold out?
    sold_out = 
      stringr::str_detect(
        title, 
        "sold out|SOLD OUT|uitverkocht|UITVERKOCHT"
        ),
    # timestamp of this run
    timestamp = Sys.time()
  ) %>%
  
  # convert lat,lon, attending (from simfuny website) to numeric
  dplyr::mutate_at(
    dplyr::vars(lat, long, attending),
    as.numeric
  )

# clean up duplicated or unnecessary cols
events <-
  events %>%
  mutate(
    fb_nums = NULL,
    date = NULL,
    date2 = NULL
  )


# 6. Get Distance to Rembrandtplein -----------

events <- get_distance_to_rembrandt(events)

# 6. Dump run into MonetDB --------------------

# store/append data in a db 
stored_ok <- store_data_in_db(events)

# halt if something went wrong
stopifnot(stored_ok)


# 7. Map events ------------------------------
#
# REMARK : This part should be optional and
# actually removed from here.
# TODO remove from here to an (optional part) or smth?

library("leaflet")

events_map <-
  leaflet::leaflet(data = events) %>%
  leaflet::addProviderTiles(
    leaflet::providers$CartoDB.Positron
    ) %>%
  leaflet::setView(lat = 52.3702, lng = 4.8952, zoom = 14) %>%
  leaflet::addAwesomeMarkers(
    lng = ~ long, lat = ~ lat,
    label = ~ title) %>% 
  leaflet::ad
#%>% leaflet::addCircles(radius = ~ fb_going)

events_map

library("mapview")
map_view <- 
  mapview(rembrandtplein) %>% 
  leaflet::addCircleMarkers(st_transform(events_sf, crs = 4326L), color = "purple") 


mapview(st_transform(events_sf, crs = 4326L)) %>% 
  leaflet::addPolygons(st_transform(rembrandtplein, crs = 4326L,color = "purple") )
