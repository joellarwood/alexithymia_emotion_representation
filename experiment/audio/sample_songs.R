##################################################################
##                        Song Selection                        ##
##################################################################

library(tidyverse)
library(here)
library(ggrepel)
library(svglite)
library(av)
set.seed(1234)

## ----------------------------
##  Identify candidate songs
## ----------------------------


media_eval <- read_csv(
  here::here( # import annotations
    "experiment",
    "audio",
    "annotations",
    "static_annotations.csv"
  )
)

tertile_valence <- quantile(media_eval$mean_valence, c(.333, .666)) # create upper and lower tertile for valence
tertile_arousal <- quantile(media_eval$mean_arousal, c(.333, .666)) # create upper and lower tertile for arousal

media_eval_filter <- media_eval %>%
  filter(!between(mean_valence, tertile_valence[1], tertile_valence[2]) & # keep only values outside of middle valence tertile
    !between(mean_arousal, tertile_arousal[1], tertile_arousal[2])) # keep only values outside of middle arousal tertile

candidate_songs <- read_csv(here::here(
  "pre_launch",
  "stimulus_selection",
  "annotations",
  "songs_info.csv"
)) %>%
  inner_join(media_eval_filter) %>%
  mutate(level = case_when(
    mean_arousal < tertile_arousal[1] &
      mean_valence < tertile_valence[1] ~ "Low Valence / Low Arousal",
    mean_arousal < tertile_arousal[1] &
      mean_valence > tertile_valence[2] ~ "High Valence / Low Arousal",
    mean_arousal > tertile_arousal[2] &
      mean_valence > tertile_valence[2] ~ "High Valence / High Arousal",
    mean_arousal > tertile_arousal[2] &
      mean_valence < tertile_valence[1] ~ "Low Valence / High Arousal"
  ))

candidate_plot <- ggplot2::ggplot( # plot songs that fall in desired range
  candidate_songs,
  aes(
    x = mean_valence,
    y = mean_arousal
  )
) +
  geom_point() +
  theme_classic()

candidate_plot
## ---------------------------------------------------------------
##            Random stratification of songs by genre           -
## ---------------------------------------------------------------

genre_count <-
  as.list(
    table(
      candidate_songs$level, candidate_songs$Genre
    )[2, ] # show genre layout for positive valence low arousal
  )

# Stratify based on genre count from the postive valence and Low arousal condition
classical <- candidate_songs %>%
  filter(Genre == "Classical") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Classical)

country <- candidate_songs %>%
  filter(Genre == "Country") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Country)

folk <- candidate_songs %>%
  filter(Genre == "Folk") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Folk)

jazz <- candidate_songs %>%
  filter(Genre == "Jazz") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Jazz)

pop <- candidate_songs %>%
  filter(Genre == "Pop") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Pop)

rock <- candidate_songs %>%
  filter(Genre == "Rock") %>%
  group_by(level) %>%
  dplyr::sample_n(genre_count$Rock)


selected_songs <- bind_rows(
  classical,
  folk,
  country,
  pop,
  rock,
  jazz
) %>%
  ungroup()

write.csv(
  selected_songs,
  file = here::here(
    "experiment",
    "audio",
    "selected_songs.csv"
  )
)

table(selected_songs$level, selected_songs$Genre)

chosen_plot <- ggplot2::ggplot(
  data = selected_songs,
  mapping = aes(
    x = mean_valence,
    y = mean_arousal,
    shape = level,
    color = Genre,
    label = song_id
  )
) +
  ggplot2::geom_point() +
  ggplot2::theme_classic() +
  ggrepel::geom_text_repel()


chosen_plot

ggplot2::ggsave(
  here::here(
    "experiment",
    "audio",
    "selected_songs.svg"
  )
)


## -----------------
##  Move selected
## -----------------

chosen <- selected_songs$file_name

dest_full_files <- here::here( # set destination folder
  "experiment",
  "audio",
  "full_files"
)

unlink( # delete existing files in folder
  paste0(
    dest_full_files, "/*"
  )
)


for (i in (1:32)) { # moves files from my download folder to the project folder
  name_tmp <- chosen[i]
  file_tmp <- paste0("/Users/joellarwood/Desktop/clips_45seconds/", name_tmp)
  file.copy(file_tmp, dest_full_files)
}


## -------------------
##  Sample selected
## -------------------

dest_samples <- here::here(
  "experiment",
  "audio",
  "samples"
)

unlink( # delete existing files in folder
  paste0(
    dest_samples, "/*"
  )
)

random_files <- sample( # randomised order of files
  chosen,
  32,
  replace = FALSE
)

random_times <- round(
  runif( # get randopm start times for the early category
    n = 32,
    min = 15,
    max = 38
  ),
  2
)

start_times <- data.frame() # initiate data frame for song info

for (i in c(1:32)) {
  tmp_file <- random_files[i] # select song
  tmp_start <- random_times[i] # start song at random point
  av::av_audio_convert(
    audio = paste0(dest_full_files, "/", tmp_file),
    output = paste0(dest_samples, "/", tmp_file),
    start_time = tmp_start,
    total_time = 5 # get 5 seconds from start point
  )
  tmp_df <- cbind(tmp_file, tmp_start) # save start time
  start_times <- rbind(tmp_df, start_times) # write df with file and start time
}

write.csv( # write start times to file
  start_times,
  paste0(
    dest_samples, "/start_times.csv"
  )
)
