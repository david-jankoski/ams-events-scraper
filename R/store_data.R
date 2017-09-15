# Store data in a local db 

# Store the data gathered from current run into
# a db on disk instance in data/ dir.
# Function checks if data/db dir exists first,
# and depending on this either appends to 
# pre-existing table or just creates new one.
store_data_in_db <- function(events) {
  
  library("MonetDBLite")
  library("DBI")
  
  # don't append to db if dir created succesfully
  # append otherwise (dir create failed)
  db_append <- suppressWarnings( !dir.create("data/db") )
  
  # start embedded monetdb in dir "db"
  db_con <- DBI::dbConnect(MonetDBLite::MonetDBLite(), "data/db")
  
  # dump this run's data
  DBI::dbWriteTable(db_con, "events", events, append = db_append)
}
