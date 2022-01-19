# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- gender_plot ----
# Bar graph
ggplot(df_combined, aes(x = as.factor(gender), weight =weight_mec)) +
  geom_bar(color = 'black', fill = 'grey') +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..))),
            stat = 'count',
            color = 'black',
            vjust = -0.5) +
  scale_x_discrete(labels = c('female', 'male')) +
  theme(axis.title.x = element_blank()) +
  labs(title = 'Gender')

## ---- gender_stats ----
# Count
wtd.table(gender, weight_mec, type = 'table')

# Male proportion
svymean(~gender, svy1)
