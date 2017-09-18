library("Rfacebook")
library("tidyverse")

app_id <- 1933337920258629
app_scrt <- "96884cc4570c3799ea4d7d83d0cdf22b"

fb_auth <- fbOAuth(app_id, app_scrt,
                   extended_permissions = TRUE)

# get all liked pages
liked_pages <- getLikes("me", token = fb_auth)

get_page_events <- function(page_id, auth_token) {

  events <- Rfacebook::getEvents(page_id, auth_token)

  if (nrow(events) == 0L) {
    return(NULL)
  }

  events <-
    events %>%
    mutate(
      date =
        as.Date(
          start_time, format = "%Y-%m-%d"
          )
    ) %>%
    filter(date >= Sys.Date())

  Sys.sleep(runif(1L, 1, 3))
  events
}
# for each liked page (like bar etc.) get their upcoming
# events
fb_events <-
  map_df(liked_pages$id, get_page_events, auth_token = fb_auth)



# NOTES
# Page "Backroom" seems to be dead, last event in 2016 ?
# Actually a lot of the pages seem to be dead - better
# clean up and add more active ones.
