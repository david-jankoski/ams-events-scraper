# Functions to query db with scraped data

library("MonetDBLite")
library("DBI")

# start embedded monetdb in dir "db"
db_con <- DBI::dbConnect(MonetDBLite::MonetDBLite(), "data/db")

# example query - events with more than 1000 ppl attending ?
DBI::dbGetQuery(db_con, "SELECT * FROM events WHERE attending > 1000")
# dplyr's db backend to query
events_db <- dplyr::tbl(db_con, "events")
events_db %>% dplyr::filter(fb_interested > 1000)
