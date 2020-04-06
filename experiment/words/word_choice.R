
#################################################################
##                    Select Emotion Words                     ##
##         Using NRC Valence/Arousal/Dominence Lexicon         ##
#################################################################

library(tidyverse)

## ---------------------------------------------------------------
##                        Candidate words                       -
## ---------------------------------------------------------------

erbas <- c(
  "angry",
  "stressed",
  "anxious",
  "irritated",
  "sad",
  "depressed",
  "excited",
  "happy",
  "satisified",
  "relaxed"
)

demiralp <- c(
  "angry",
  "frustrated",
  "anxious",
  "disgusted",
  "ashamed",
  "sad",
  "alert",
  "excited",
  "happy",
  "active"
)

larwood <- c(
  "sad",
  "anxious",
  "frustrated",
  "ashamed",
  "guilty",
  "happy",
  "excited",
  "alert",
  "active",
  "tender",
  "scared"
)

barrett <- c(
  "excited",
  "lively",
  "cheerful",
  "pleased",
  "calm",
  "relaxed",
  "idle",
  "still",
  "dulled",
  "bored",
  "unhappy",
  "disapointed",
  "nervous",
  "fearful",
  "alert",
  "aroused"
)

words <- c(
  erbas,
  demiralp,
  larwood,
  barrett
)

word_counts <- words %>%
  as_tibble() %>%
  group_by(value) %>%
  summarise(
    n = n()
  ) %>%
  dplyr::arrange(desc(n))

word_counts %>%
  ggplot2::ggplot(
    aes(
      x = reorder(value, n),
      y = n
    )
  ) +
  ggplot2::geom_linerange(
    aes(
      ymin = 0,
      ymax = n
    )
  ) +
  ggplot2::geom_point() +
  xlab("word") +
  ylab("count") +
  theme_classic() +
  theme(axis.text.x = element_text(
    angle = 270
  ))


nrc_vad <- read_table2(
  file = here::here(
    "experiment",
    "words",
    "NRC-VAD-Lexicon.txt"
  )
) %>%
  filter(Word %in% words) %>%
  mutate_at(
    c("Valence", "Arousal"),
    as.numeric
  ) %>%
  left_join(word_counts,
    by = c("Word" = "value")
  ) %>% 
  mutate(count = as_factor(n))

ggplot2::ggplot(
  nrc_vad,
  aes(
    x = Valence,
    y = Arousal,
    color = count,
    label = Word
  )
) +
  ggplot2::geom_point() +
  ggrepel::geom_text_repel()

ggsave(
  here::here(
    "experiment",
    "words",
    "candidate_words.svg"
  )
)
