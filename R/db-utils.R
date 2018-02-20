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

#' Connect to a MonetDBLite stored on disk
#'
#' @param db_dir Path to directory where MonetDBLite instance sits
#' @param table_name Name of table to connect to, defaults to first table name found in this db dir.
#'
#' @return A tbl_monetdb object as returned by dplyr's db-backend. You can manipulate this lazy tbl
#' with the usual dplyr verbs.
#'
#' @export
#'
#' @examples
#'
#' db <- ht_monetdb_connect("path/to/local/monetDB")
#'
events_db_connect <- function(db_dir, table_name = NULL) {

  # bring up libs
  packs <- c("MonetDBLite", "DBI", "dplyr")
  suppressMessages(suppressWarnings(sapply(packs, require,
                                           quietly = TRUE,
                                           character.only = TRUE,
                                           warn.conflicts = FALSE,
                                           USE.NAMES = FALSE)))
  # Connect to local monetDB
  db <- MonetDBLite::src_monetdb(embedded = db_dir)

  # Get the table name from the DB
  if (is.null(table_name)) {
    table_name <- dplyr::src_tbls(db)[1]
    message("No table specified - connecting to: ", table_name, "\n",
            "(available tables: ", paste(src_tbls(db), collapse = "; "), ")")
  }
  # Connect to table
  db_table <- dplyr::tbl(db, table_name)
}


#' Given a db object from \code{ht.monetDB.connect()}, retrieve the
#' embedded connection object and shut it down.
#' It helps to avoid restarting R sessions to connect and reconnect.
#'
#' @param db a tbl_monetdb object
#' @return
#' @export
#' @examples
#' db <- ht_monetdb_connect("path/to/local/monetDB")
#' ht_monetdb_disconnect(db)
events_db_disconnect <- function(db) {
  DBI::dbDisconnect(db$src$con, shutdown = TRUE)
}
