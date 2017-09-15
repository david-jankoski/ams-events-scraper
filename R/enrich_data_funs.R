# Enrich data functions 

# helper fun to extract first 3 chars from event date
# as the abbrev weekday name
get_dates_wday <- function(dates) stringr::str_sub(dates, 1L, 3L)

# helper fun to convert event dates from chars to datetimes
convert_dates <- function(dates) {
  as.Date.character(
    stringr::str_sub(dates, start = -5L),
    format = "%d-%m"
  )
}
