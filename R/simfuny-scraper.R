
#' Title
#'
#' @return
#' @export
#'
#' @examples
#' @importFrom magrittr "%>%"
simfuny_scrape <- function() {

  # Make the simfuny url
  simfuny_url <-
    make_simfuny_url(num_events = 50, time_range = "month")

  # Collect events data
  events <- get_simfuny_events(simfuny_url)

  # Create event-links from titles
  events <-
    events %>%
    dplyr::mutate(
      event_link = purrr::map2_chr( nid, title, create_simfuny_event_link )
    )


  # Get fb link for each event

  # Initialise docker daemon in background
  dkrid <- sys::exec_background("sudo", "dockerd")
  Sys.sleep(10)

  # Start splash
  sp <- splashr::start_splash()
  Sys.sleep(10)

  # if all went ok this should return TRUE
  stopifnot(splashr::splash_active())

  # Render each simfuny event link html and
  # grab the "Meer Info" link leading to
  # (most probably) the corresponding fb event link
  events <-
    events %>%
    dplyr::mutate(
      fb_link = purrr::map_chr(event_link, create_fb_event_link)
    )

  # Get fb attendance -------

  # Render each fb_link and return the attendance nums
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
  stored_ok <- store_data_in_db(events, "data/db", "events")

  # halt if something went wrong
  stopifnot(stored_ok)


  # 7. Clean up & exit --------

  # stop splash container
  splashr::stop_splash(sp)
  Sys.sleep(5)

  # stop dockerdaemon
  tools::pskill(dkrid)
  Sys.sleep(5)

}
# # 7. Map events ------------------------------
# #
# # REMARK : This part should be optional and
# # actually removed from here.
# # TODO remove from here to an (optional part) or smth?
#
# library("leaflet")
#
# events_map <-
#   leaflet::leaflet(data = events) %>%
#   leaflet::addProviderTiles(
#     leaflet::providers$CartoDB.Positron
#     ) %>%
#   leaflet::setView(lat = 52.3702, lng = 4.8952, zoom = 14) %>%
#   leaflet::addAwesomeMarkers(
#     lng = ~ long, lat = ~ lat,
#     label = ~ title) #%>%
#   #leaflet::addCircles(radius = ~ fb_going)
#
# events_map
#
# library("mapview")
#
# rembrandtplein <- readRDS("data/rembrandtplein_polygon_sf.rds")
# rembrandtplein <- rembrandtplein$finished
#
# map_view <-
#   mapview(rembrandtplein) %>%
#   leaflet::addCircleMarkers(., lng = ~ events$long,
#                             lat = ~ events$lat,
#                             color = "purple")
