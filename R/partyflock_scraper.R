
# In order this to work you need to start
# Rstudio with sudo rstudio !

# Run dockerd as a background process
dkrid <- sys::exec_background("sudo", "dockerd")

# Kill dockerd when fun exits
on.exit(tools::pskill(dkrid))

library("splashr")
splashr::start_splash()
splashr::splash_active()

partyflock_url <- "http://partyflock.nl/city/1:Amsterdam"

# render partyflock page
partyflock_html <-
  splashr::render_html(url = partyflock_url, wait = 10)

# there must be a better way to do this!
# get to the crappy table
pf_tab <-
  partyflock_html %>%
  rvest::html_node(css = "#agenda .box-column:nth-child(1)")

# extract text from super crappy table
pf_text <-
  pf_tab %>%
  rvest::html_nodes("tr") %>%
  rvest::html_text()

# try and get to the links
# BROKEN - FIX ME !
rvest::html_nodes(pf_tab, css = "href")

# throw away bunch of empty strings at beginning
pf_text <- pf_text[stringr::str_detect(pf_text, "")]

# indexes of text lines of days
# e.g. "vandaag, vrijdag 15 september 2017"
days_delim <- which(stringr::str_detect(pf_text, "^[a-z]"))

# TODO this so messy - untangle spagetti here
#
# locate todays delim "vandaag" and throw away the yesterday delim
# the text at the location of the days_delim's - which one is "vandaag" ?
today_delim <- which(stringr::str_detect(pf_text[days_delim[1:5]], "vandaag"))
# the day delimiters at that index is the line in the original text where
# today starts
today_delim <- days_delim[today_delim]

# lines 1 up to before today_delim line are past info
past_info_idx <- 1:(today_delim - 1L)
# remove past info
pf_text <- pf_text[-past_info_idx]

# update day delimiters to new state
days_delim <- which(stringr::str_detect(pf_text, "^[a-z]"))

# TODO maybe limit future range to only 14 days ahead ?
# this should print out date roughly 2 weeks from now
# maybe minus 1 day (so 15 instead of 14 ?)
two_weeks_ahead <- pf_text[days_delim[14]]


# Switch to dataframe ------------

# convert to dataframe
pflock <-
  tibble::data_frame(
    text = pf_text,
    day_breaks)

pflock <-
pflock %>%
  mutate(
    day_break = str_detect(text, "vandaag|2017")
  )
pflock$day_break[1] <- TRUE

pflock <-
pflock %>%
  mutate(
    day_group = cumsum(day_break)
  )

pflock <-
pflock %>%
  mutate(
    event_name = map_chr(str_split(text, pattern = "[0-9]+"), 1)
  )

str_split(pf_text[6:10], pattern = "[0-9]") %>%
  map(1)

pflock %>% group_by(day_group) %>% filter(!day_break) %>%
  mutate(event)



