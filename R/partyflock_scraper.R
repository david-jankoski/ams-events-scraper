
# In order this to work you need to start
# Rstudio with sudo rstudio !

# Run dockerd as a background process
dkrid <- sys::exec_background("sudo", "dockerd")

# Kill dockerd when fun exits
on.exit(tools::pskill(dkrid))

# start splash
library("splashr")
splashr::start_splash()
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
    date_id = cumsum(wrong_rows)
  )

partyflock_df <-
  partyflock_df %>%
  group_by(date_id) %>%
  mutate(
    date =
      stringr::str_extract_all(first(event_name), "[0-9]+.*"),
    date = unlist(date)
  ) %>%
  ungroup() %>%
  filter(!wrong_rows) %>%
  mutate(
    event_location =
      purrr::map_chr(
        stringr::str_split(
          event_location,
          "AmsterdamNederland"
        ),
        1L
      )
  )

partyflock_df$wrong_rows <- NULL
partyflock_df$date_id <- NULL

partyflock_df$timestamp <- Sys.time()

# -------
days_delim2 <-
  which(stringr::str_detect(partyflock_df$event_name, "dag.*[0-9]+.*201[78]"))

partyflock_df$event_name[days_delim2] %>%
  stringr::str_extract_all("[0-9]+.*")
