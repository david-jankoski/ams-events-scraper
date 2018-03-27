
#' @title Store data in a local db
#'
#' @description Store the data gathered from current run into
#' a db on disk instance in db_dir.
#' Function checks if db_dir dir exists first, and depending
#' on this either appends to pre-existing table or just creates new one.
#'
#' @param events dataframe, scraped data from current run
#' @param db_dir string - path to dir where db should be/is
#' @param table_name string - name of table
#'
#' @return TRUE on success, FALSE if something went wrong.
#' @export
#'
#' @examples
store_data_in_db <- function(events, db_dir, table_name) {

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

#' @title Connect to a table on local db instance
#'
#' @description Given a path to a dir of local db instance and
#' a table name - connect to local db in order to work with data.
#'
#' @param db_dir string - path to where db sits
#' @param table_name string - name of table to connect to
#'
#' @return A handle on the table in the db for further data management.
#' @export
#'
#' @examples
events_db_connect <- function(db_dir, table_name = NULL) {
  # must provide table name (which source of data)
  stopifnot(!is.null(table_name))
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
