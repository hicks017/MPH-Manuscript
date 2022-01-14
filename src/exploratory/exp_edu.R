# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- edu_plot ----
# Bar graph
ggplot(subset(df_combined, !is.na(education)),
       aes(x = as.factor(education), weight =weight_mec)) +
  geom_bar(color = 'black', fill = 'grey') +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..))),
            stat = 'count',
            color = 'black',
            vjust = -0.5) +
  scale_x_discrete(labels = c('No diploma',
                              'H.S./GED',
                              'Some college',
                              'College')) +
  theme(axis.title.x = element_blank()) +
  labs(title = 'Education')

## ---- edu_stats ----
# Counts
wtd.table(education, weight_mec, type = 'table')

# Proportions
wtd.table(education, weight_mec, type = 'table') %>% 
  prop.table() %>% 
  round(3)
