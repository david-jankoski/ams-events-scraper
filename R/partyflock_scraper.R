
# In order this to work you need to start
# Rstudio with sudo rstudio !
library("tidyverse")

# Run dockerd as a background process
dkrid <- sys::exec_background("sudo", "dockerd")
# Kill dockerd when fun exits
#on.exit(tools::pskill(dkrid))
Sys.sleep(10)

# start splash wait till init done
library("splashr")
splashr::start_splash()
Sys.sleep(10)

# halt if smth goes wrong
stopifnot(splashr::splash_active())

# partyflock.nl url for parties in ams
partyflock_url <- "http://partyflock.nl/city/1:Amsterdam"

# render partyflock page
partyflock_html <-
  splashr::render_html(url = partyflock_url, wait = 10)

# extract table into datafame
partyflock_df <-
  partyflock_html %>%
  rvest::html_node("table.partylist.fw.nocellbrd.vtop") %>%
  rvest::html_table()

# better names, remove empty
partyflock_df$X2 <- NULL

colnames(partyflock_df) <-
  c("event_name", "attending", "event_location")

# which rows are actually days
days_delim <-
  stringr::str_detect(partyflock_df$event_name, "dag.*[0-9]+.*201[78]")

# days idxs in df
days_delim_idx <- which(days_delim)
# get only the days out
dates <- partyflock_df$event_name[days_delim_idx]

# get idx of today (2 past dates not of interest)
today_delim_idx <-
  dates %>%
  stringr::str_detect("vandaag") %>%
  which()
# construct idxs of past days
past_events <-
  1:(days_delim_idx[today_delim_idx] - 1)
# remove them
partyflock_df <- partyflock_df[-past_events, ]

partyflock_df <-
  partyflock_df %>%
  mutate(
    # update wrong rows (got mangled by removing past events)
    wrong_rows = stringr::str_detect(event_name, "dag.*[0-9]+.*201[78]"),
    # simple way to attach each date an id
    date_id = cumsum(wrong_rows),
    # convert attending to integer
    attending = as.integer(attending)
  )

partyflock_df <-
  partyflock_df %>%
  # for each group (per date id) extract the
  # actual date out of the event_name
  # it's the first row of each group (cf. html-table)
  group_by(date_id) %>%
  mutate(
    date =
      stringr::str_extract(first(event_name), "[0-9]+.*"),
    # holiday dates have a ", holidayname" at the end
    # get that out in a sep col
    date = stringr::str_split(date, ","),
    holiday = unlist(map(date, 2L)) %||% NA_character_,
    #holiday = holiday ,
    date = map_chr(date, 1L),
    # parse into POSIX
    date =
      lubridate::parse_date_time(
        date,
        orders = "db!Y",
        locale = "nl_NL.utf8"
      ),
    # get the day of week as labeled factor (e.g. Fri)
    date_wday = lubridate::wday(
      date,
      label = TRUE, abbr = TRUE
      )
  ) %>%
  ungroup() %>%
  # dates are extracted, don't need the rows containing
  # them anymore
  filter(!wrong_rows) %>%
  mutate(
    # the event location seems to be mangled and
    # smth like
    # ParadisoAmsterdamNederlandParadiso
    # so split-and-pick first part
    event_location =
      purrr::map_chr(
        stringr::str_split(
          event_location,
          "AmsterdamNederland"
        ),
        1L
      ),
    event_location =
      ifelse(event_location == "", NA_character_, event_location)
  )


# remove unneded cols
partyflock_df$wrong_rows <- NULL
partyflock_df$date_id <- NULL

# timestamp of scraping
partyflock_df$timestamp <- Sys.time()

# stop the docker daemon
tools::pskill(dkrid)

# 6. Dump run into MonetDB --------------------

# store/append data in a db
stored_ok <- store_data_in_db(partyflock_df, "data/db", "partyflock")

# halt if something went wrong
stopifnot(stored_ok)



# -----
# maybe add some visualisation of the
# partyflock attendance ?

# ggplot(partyflock_df,
#        aes(forcats::fct_reorder(factor(event_location), attending), attending))+
#   geom_col()
