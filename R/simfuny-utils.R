# Simfuny scraper utilility functions

#' Make the simfuny events url
#'
#' @param num_events number of events to return
#' @param time_range time range of events week/month only supported for now
#'
#' @return string of the appropriate url to get the json response back
#' @export
#'
#' @examples
make_simfuny_url <- function(num_events = 50, time_range = "month") {

  # go to simfuny.com/events, select date "Deze Week/Maand" (time_range),
  # sort by "Populair" and tick the Festival, Nachtleven, Voorstelling
  # inspecting the network call it makes - this seems to be the link for
  # getting the response for top [num_events] most popular events this week.
  events_url <-
    glue::glue(
      "http://api.simfuny.com/app/api/2_0/events?",
      "callback=__ng_jsonp__.__req1.finished&",
      "offset=0&limit={num_events}&",
      "sort=popular&search=&",
      "types[]=unlabeled&dates[]={time_range}&",
      "startDate=&endDate=&",
      "hosts[]=Festivals&",
      "hosts[]=Nightlife&",
      "hosts[]=Performing Arts&",
      "hosts[]=Uncategorized&hidelongterm=1"
    )

  events_url
}

safe_GET <- function(url) {

  sget <- purrr::safely(httr::GET)

  out <- sget(url)

  if (!is.null(out$error)) {
    stop("something went wrong when fetching simfuny url \n",
         out$error)
  }

  httr::stop_for_status(
    out$result, task = "pull data from simfuny website.")

  out$result
}

#' Title
#'
#' @param simfuny_url
#'
#' @return
#' @export
#'
#' @examples
#' @importFrom magrittr "%>%"
get_simfuny_events <- function(simfuny_url) {

  # collect events in dataframe
  simfuny_events <-
    simfuny_url %>%
    # get url content as text
    safe_GET() %>%
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

  simfuny_events
}


#' Construct simfuny event urls
#'
#' @description Given a simfuny event-id and event-title
#' constructs the appropriate link e.g. event with title
#' "Some Great Party 2017" and id 123
#' will have a link "www.simfuny.com/events/123/some-great-party-2017"
#' Titles are all lower case and "-" separated.
#' This was a trial and error exploration and might be subject to change.
#' @param event_id
#' @param event_title
#'
#' @return
#' @export
#'
#' @examples
#' @importFrom magrittr "%>%"
create_simfuny_event_link <- function(event_id, event_title) {

  # TODO french E might cause problems
  event_title <-
    event_title %>%
    tolower() %>%
    stringr::str_replace_all(pattern = "\\W+", replacement = "-")

  # sometimes a trailing "-" is left over by replacing punct
  # shave off if this is the case
  if ( stringr::str_detect(event_title, pattern = "-$") ) {
    event_title <-
      stringr::str_sub(event_title, end = -2L)
  }

  # simfuny base url
  base_url <- "http://simfuny.com/event"

  # event link 123/my-party
  paste(base_url, event_id, event_title, sep = "/")
}
