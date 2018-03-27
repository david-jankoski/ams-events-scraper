
# TODO revisit this file as it used to be
# a script - needs to be turned into function
get_loc_coords <- function() {

  events_url <-
    "http://api.simfuny.com/app/api/2_0/events?callback=__ng_jsonp__.__req1.finished&limit=10000&dates[]=between&startDate=2017-09-01&endDate=2017-12-01&hidelongterm=0"

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

  ams_locations <- events %>% select(location, lat, long) %>% distinct()

  ams_locations$lat <- as.numeric(ams_locations$lat)
  ams_locations$long <- as.numeric(ams_locations$long)


  mult_coords <-
    ams_locations %>%
    count(location) %>%
    filter(n != 1)

  ams_locations <-
    ams_locations %>%
    group_by(location) %>%
    slice(1) %>%
    ungroup()

  saveRDS(ams_locations, "data/ams_locations_latlong.rds")


  ams_locations %>%
    left_join(pf, ., by = c("event_location" = "location")) -> pf2

  pf3 <-
    stringdist_left_join(pf, ams_locations, by = c(event_location = "location"), distance_col = T)

}
