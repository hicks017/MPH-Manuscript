# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- sitting_plot ----
# Histogram
ggplot(df_combined,
       aes(x = sitting_min_daily, weight = weight_mec)) +
  geom_histogram(binwidth = 65,
                 na.rm = T,
                 color = 'black',
                 fill = 'grey') +
  labs(title = 'Daily sitting minutes, weighted population',
       x = 'minutes',
       y = 'count') +
  geom_vline(
    aes(xintercept = svymean(~sitting_min_daily, svy1, na.rm = T),
        color = 'mean'),
    size = 1,
    linetype = 'dashed') +
  geom_vline(
    aes(xintercept = as.numeric(svyquantile(~sitting_min_daily,
                                            svy1, 0.5,
                                            ci = F,
                                            na.rm = T)[1]),
        color = 'median'),
    size = 1,
    linetype = 'dashed') +
  scale_color_manual(name = 'statistics',
                     values = c(median = 'blue', mean = 'red'))

## ---- sitting_stats ----
# Min, max, quantiles, and mean
svyquantile(~sitting_min_daily, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~sitting_min_daily, svy1)
