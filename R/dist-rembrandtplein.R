# Read in Rembrandtplein defined as a spatial polygon ------
#
# How this was done can be found in corresponding file
# draw_rembrandtplein.R in same dir.
#
read_rembrandtplein_poly <- function(poly_path) {

  # load previously drawn Rembrandplein obj
  rembrandtplein <- readRDS(poly_path)

  # extract the sf object and re-project on a more appropriate
  # gcs in order to compute distances in meters.
  # ref:
  # https://gis.stackexchange.com/questions/22843/converting-decimal-degrees-units-to-km-in-r
  # NOTE: the epsg 7415 coord ref system is an appropriate one
  # i found on the web - it describes The Netherlands (and it is called
  # EPSG 7315 Amersfoort).
  rembrandtplein <-
    rembrandtplein$finished$geometry %>%
    st_transform(crs = 7415L)

  rembrandtplein
}

# Convert to sf -----------------
#
# Convert an events dataframe into a
# spatial version with events as
# simple feature point geometries.
#
convert_to_sf <- function(events) {

  library("sf")

  # convert events dataframe to sf object
  events <-
    events %>%
    # first step is to reference in the coord system they
    # originated from (simfuny uses the "standard" EPSG:4326)
    st_as_sf(crs = 4326L, coords = c("long", "lat")) %>%
    # in order to compute distances we need to transfrom into
    # a projected coord system - EPSG:7415 is crs for NL.
    st_transform(crs = 7415L)

  events
}

# Distance to Rembrandteplein -------------
#
# Given the events dataframe, calculate the
# spatial distance metrics of each event
# to the Rembrandtplen.
#
get_distance_to_rembrandt <- function(events, near_thresh = 300) {

  library("tidyverse")
  library("sf")

  # read in rembrandtplein sf polygon
  rembrandtplein <-
    read_rembrandtplein_poly(
      "data/rembrandtplein_polygon_sf.rds"
    )

  # convert the events dataframe into a
  # simple features dataframe with spatial attributes
  # subset only on the id & long/lat columns so we
  # carry less weight.
  events_sf <-
    events %>%
    select(nid, long, lat) %>%
    convert_to_sf()

  # check if crs are equal
  stopifnot(
    all.equal(st_crs(events_sf), st_crs(rembrandtplein))
  )

  # calculate distance metrics
  events_sf <-
    events_sf %>%
    mutate(
      # nearest euclidian distance from
      # point on map to polygon defined
      # by rembrandtplein
      dist_rembrandtplein =
        st_distance(
          geometry,
          rembrandtplein,
          by_element = TRUE
        ),
      # less restrictive metric that allows for
      # a certain buffer "nearness"
      near_rembrandtplein = dist_rembrandtplein < near_thresh
    )

  # join back on original dataframe only the
  # newly created cols, omit the geometry col.
  # reason - not sure if writing to db will work if
  # we keep the sf stuff...
  events <-
    left_join(events, events_sf ,  by = "nid") %>%
    # remove sticky geometry col
    mutate(geometry = NULL)

  events
}
