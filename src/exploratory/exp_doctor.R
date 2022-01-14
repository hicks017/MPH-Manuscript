# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- doc_plot ----
# Bar graph
ggplot(subset(df_combined, !is.na(chol_doctor_hi)),
       aes(x = as.factor(chol_doctor_hi), weight =weight_mec)) +
  geom_bar(color = 'black',
           fill = 'grey') +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..))),
            stat = 'count',
            color = 'black',
            vjust = -0.5) +
  scale_x_discrete(labels = c('yes', 'no')) +
  theme(axis.title.x = element_blank()) +
  labs(title = 'Doctor says cholesterol is high, weighted')

## ---- doc_stats ----
# Counts
wtd.table(chol_doctor_hi, weight_mec, type = 'table')

# Proportions
wtd.table(chol_doctor_hi, weight_mec, type = 'table') %>% 
  prop.table() %>% 
  round(3)
