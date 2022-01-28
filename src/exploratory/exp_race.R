# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- race_plot ----
# Bar graph
ggplot(df_combined, aes(x = as.factor(race_eth), weight =weight_mec)) +
  geom_bar(color = 'black', fill = 'grey') +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..))),
            stat = 'count',
            color = 'black',
            vjust = -0.5) +
  scale_x_discrete(labels = c('Hispanic',
                              'White',
                              'Black',
                              'Asian',
                              'Other')) +
  theme(axis.title.x = element_blank()) +
  labs(title = 'Race/Ethnicity')

## ---- race_stats ----
# Counts
wtd.table(gender, weight_mec, type = 'table')

# Proportions
wtd.table(gender, weight_mec, type = 'table') %>% 
  prop.table() %>% 
  round(4)
