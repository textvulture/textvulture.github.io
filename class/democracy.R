library(vdemdata) 
library(dplyr)
library(ggplot2)

data <- vdem %>% select("country_id", "country_name", "year",
                "v2x_polyarchy")

data %>% 
  ggplot(aes(x=year, y=v2x_polyarchy)) +
  geom_line(alpha = 0.25, 
            aes(group=factor(country_id),
                fill='gray')) +
  geom_smooth(se=F, color='red') +
  theme_minimal() +
  labs(y="democracy") +
  theme(legend.position = 'none',
        text = element_text(size=15))