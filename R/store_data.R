# Store data in a local db

# Store the data gathered from current run into
# a db on disk instance in data/ dir.
# Function checks if data/db dir exists first,
# and depending on this either appends to
# pre-existing table or just creates new one.
store_data_in_db <- function(events, db_dir, table_name) {

  library("MonetDBLite")
  library("DBI")

  # don't append to db if dir created succesfully
  # append otherwise (dir create failed)
  db_append <- suppressWarnings( !dir.create(db_dir) )

  # start embedded monetdb in dir "db"
  db_con <- DBI::dbConnect(MonetDBLite::MonetDBLite(), db_dir)

  # dump this run's data
  DBI::dbWriteTable(db_con, table_name, events, append = db_append)
  # shutdown db con
  DBI::dbDisconnect(db_con)
}

#
events_db_connect <- function(db_dir, table_name = NULL) {

  stopifnot(!is.null(table_name))
  # bring up libs
  packs <- c("MonetDBLite", "DBI", "dplyr")
  invisible(
    sapply(
      packs, library,
      character.only = TRUE, quietly = TRUE
    )
  )
  # Connect to local monetDB
  db <- MonetDBLite::src_monetdb(embedded = db_dir)
  # Connect to table
  db_table <- dplyr::tbl(db, table_name)

  db_table
}
