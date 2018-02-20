# Simfuny helper funs 

# helper fun that given a simfuny event-id and event-title
# constructs the appropriate link
# e.g. An event with title "Some Great Party 2017" and id 123
# will have a link "www.simfuny.com/events/123/some-great-party-2017"
# this was a trial and error exploration and might be subject to change.
#
create_simfuny_event_link <- function(event_id, event_title) {
  
  # event titles are all lower case and "-" separated
  # e.g. "My Party" will have a link ..../123/my-party
  #
  # TODO (add doc about punctuation stuff)
  ## need to replace
  # & , (), / , // , ',   <-- DONE
  # french E
  
  # leave in
  # sold out , - ,
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
