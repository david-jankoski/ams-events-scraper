# Facebook helper funs 

# helper fun to get fb events from dataframe
create_fb_event_link <- function(event_link) {
  
  # render the html from event_link, wait a bit
  pg <- splashr::render_html(url = event_link, wait = 10)
  # parse the html to get to Meer Info button
  # which has large-link class and get the
  # corresponding href link inside
  fb_link <-
    pg %>%
    rvest::html_node(css = ".large-link") %>%
    rvest::html_attr("href")
  
  Sys.sleep( runif(1, min = 1, max = 6) )
  fb_link
}

# helper fun to parse "1.3K Going" or "912 Interested"
parse_fb_nums <- function(x) {
  
  out <-
    ifelse(
      # check if there is a "K" after the number
      stringr::str_detect(x, "\\d*K"),
      # if yes, extract num and make it in thousands
      as.numeric(
        stringr::str_extract(x, pattern = "\\d+\\.?\\d*")
      ) * 1000,
      # if not as is
      as.numeric(
        stringr::str_extract(x, pattern = "\\d+")
      )
    )
  # conver result to integer
  as.integer(out)
}

# function that given a link to fb event,
# renders, parses and extracts from the html
# the attendance metrics : Going & Interested.
#
# TODO (rethink better output ?)
get_fb_attendance <- function(fb_link) {
  
  # render html of fb event page
  fb_cont <- splashr::render_html(url = fb_link, wait = 10)
  
  # grab the element with the weird name
  # and extract the 2 numbers where the
  # first one is Going and the second one
  # is Interested.
  # TODO (prove that this is consistent?)
  fb_nums <-
    fb_cont %>%
    rvest::html_node(css = "._5z74")
  
  # If link was not fb return NAs
  if ( purrr::is_empty(fb_nums) ) {
    return(
      list(fb_going = NA_integer_,
           fb_interested = NA_integer_
      )
    )
  }
  
  # else proceed to process fb attnd nums
  fb_nums <-
    fb_nums %>%
    rvest::html_text() %>%
    stringr::str_split(stringi::stri_escape_unicode("·")) %>%
    unlist() %>%
    stringr::str_trim() %>%
    purrr::map(parse_fb_nums) %>%
    purrr::set_names(c("fb_going", "fb_interested"))
  
  # sleep some random time before coming back from fun 
  Sys.sleep( runif(1, min = 1, max = 6) )
  
  fb_nums
}
