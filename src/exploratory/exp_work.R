# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
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
# Min, max, quantiles, and mean with standard errors
svyquantile(~wrk_hrs, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~wrk_hrs, svy1)

# Equal to 40 hours
wrk_tbl <- wtd.table(wrk_hrs, weights = weight_mec)
wrk_tbl$sum.of.weights[11] / wrk_tbl$sum.of.weights %>% sum()
# Over 40 hours
wrk_tbl$sum.of.weights[12:47] %>% sum() / wrk_tbl$sum.of.weights %>% sum()
# Under 40
wrk_tbl$sum.of.weights[1:10] %>% sum() / wrk_tbl$sum.of.weights %>% sum()

# Gender stratification, mean hours
df_female <- df_combined %>% subset(gender == 0)
df_male <- df_combined %>% subset(gender == 1)
wtd.mean(df_female$wrk_hrs, weights = df_female$weight_mec)
wtd.mean(df_male$wrk_hrs, weights = df_male$weight_mec)
