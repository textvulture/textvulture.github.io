library(tibble)
library(tinytable)
library(ggplot2)
library(dplyr)


grading_tbl <- tibble(
  `GradingItem` = c(
    "My Views on \nGlobalization (5%)",
    "Critical Review (10%)",
    "Critical Review \nDiscussion (10%)",
    "Map Quiz (5%)",
    "Participation (10%)",
    "Mid-term Exam (30%)",
    "Final Exam (30%)"
    ),
  `Percentage` = c(
    5,
    10,
    10,
    5,
    10,
    30,
    30
  )
)

library(ggrepel)

grading_tbl %>%
  mutate(
    fraction = Percentage / sum(Percentage),
    ymax     = cumsum(fraction),
    ymin     = lag(ymax, default = 0),
    ymid     = (ymax + ymin) / 2
  ) %>%
  ggplot(aes(ymax = ymax, ymin = ymin, 
             xmax = 4, xmin = 3, 
             fill = GradingItem,
             alpha=0.65)) +
  geom_rect(aes(color=GradingItem)) +
  coord_polar(theta = "y") +
  xlim(c(2, 5)) +
  theme_void() +
 geom_label_repel(
   aes(y=ymid, x=4, label=GradingItem),
   nudge_x = 1,
   min.segment.length = 0,
   segment.color = "grey40",
   segment.size  = 0.6
 ) +
  theme(legend.position = 'none')

