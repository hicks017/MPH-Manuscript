# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('output/data/combined.Rds')
df_male <- readRDS('output/data/male.Rds')
df_female <- readRDS('output/data/female.Rds')
# Exactly 40 hours worked
df_combined$wrk40 <- ifelse(df_combined$wrk_hrs == 40, 1, 0)
# Over 40 hours
df_combined$wrk40_over <- ifelse(df_combined$wrk_hrs > 40, 1, 0)
# Under 40 hours
df_combined$wrk40_under <- ifelse(df_combined$wrk_hrs < 40, 1, 0)
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- work_plot ----
# Histogram
ggplot(df_combined, aes(x = wrk_hrs, weight = weight_mec)) +
  geom_histogram(color = 'black', binwidth = 5, fill = 'grey') +
  ggtitle('Working Hours distribution, weighted study population') +
  theme(legend.position = 'bottom', legend.direction = 'horizontal') +
  geom_vline(aes(xintercept = wtd.mean(wrk_hrs, weight_mec), color = 'mean'),
             size = 1,
             linetype = 'dashed') +
  geom_vline(aes(xintercept = wtd.quantile(wrk_hrs, weight_mec, 0.5),
                 color = 'median'),
             size = 1,
             linetype = 'dashed') +
  scale_color_manual(name = 'statistics',
                     values = c(median = 'blue',mean = 'red')) +
  xlab('prior week working hours')

## ---- work_stats ----
# Min, max, quantiles, and mean
svyquantile(~wrk_hrs, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~wrk_hrs, svy1)

# Equal to 40 hours, over 40 hours, and under 40
svymean(~wrk40 + wrk40_over + wrk40_under, svy1)

# Gender stratification, mean hours
# Male
svy_male <- svydesign(ids = df_male$SEQN,
                      weights = df_male$weight_mec,
                      data = df_male)
svymean(~wrk_hrs, svy_male)
# Female
svy_female <- svydesign(ids = df_female$SEQN,
                      weights = df_female$weight_mec,
                      data = df_female)
svymean(~wrk_hrs, svy_female)
