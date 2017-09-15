# draw a polygon on map in order to 
# obtain roughly the Rembrandtplein area
library("mapedit")
library("mapview")
library("sf")

# open up the map viewer
rembrandtplein <- editMap(mapview())

# open the map, scroll to amsterdam,
# find rembrandtplein,
# ..draw the polygon...

# visualise selection
mapview(rembrandtplein$finished)

# save the drawn object in order to reload it in 
# later session - we will use this spatial polygon
# in order to calculate distances from points on 
# map (events) to this area of interest.
saveRDS(rembrandtplein, "data/rembrandtplein_polygon_sf.rds")

# Rembrandtplein spatial polygon represented as 
# a Well Known Text format.
rembrandtplein_wkt <- 
  glue::glue(
    "POLYGON ((",
    "121863.900623145 486546.136633659,",
    "121830.369032584 486624.24942906,",
    "121742.202408334 486680.476675484,",
    "121626.493982203 486692.384434804,",
    "121415.359596921 486693.816446951,",
    "121116.219703244 486773.748535465,",
    "120965.69439283 486674.642759986,",
    "121168.798757601 486495.217550029,",
    "121542.879304342 486414.780364836,",
    "121870.487595417 486512.71203006,",
    "121863.900623145 486546.136633659))"
  )