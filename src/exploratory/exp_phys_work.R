# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- phys_work_plot ----
# Bar graph
ggplot(subset(df_combined, !is.na(phys_work_vig)),
       aes(x = as.factor(phys_work_vig), weight =weight_mec)) +
  geom_bar(color = 'black',
           fill = 'grey') +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..))),
            stat = 'count',
            color = 'black',
            vjust = -0.5) +
  scale_x_discrete(labels = c('yes', 'no')) +
  theme(axis.title.x = element_blank()) +
  labs(title = 'Vigorous work activity')

## ---- phys_work_stats ----
# Counts
wtd.table(phys_work_vig, weight_mec, type = 'table')

# Proportions
wtd.table(phys_work_vig, weight_mec, type = 'table') %>% 
  prop.table() %>% 
  round(4)
