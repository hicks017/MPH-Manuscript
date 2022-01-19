# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
df_combined$below_pov <- ifelse(df_combined$income_pov_ratio <= 1, 1, 0)
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- poverty_plot ----
# Histogram
ggplot(df_combined, aes(x = income_pov_ratio, weight = weight_mec)) +
  geom_histogram(binwidth = 0.5, na.rm = T, fill = 'grey', color = 'black') +
  labs(x = 'ratio',
       title = 'Income to Poverty Ratio, weighted study population') +
  geom_vline(aes(xintercept = wtd.mean(income_pov_ratio, weight_mec),
                 color = 'mean'),
             size = 1,
             linetype = 'dashed') +
  geom_vline(aes(xintercept = wtd.quantile(income_pov_ratio, weight_mec, 0.5),
                 color = 'median'),
             size = 1,
             linetype = 'dashed') +
  scale_color_manual(name = 'statistics',
                     values = c(median = 'blue', mean = 'red'))

## ---- poverty_stats ----
# Min, max, and quantiles with standard errors
svyquantile(~income_pov_ratio, svy1, c(0, 0.25, 0.5, 0.75, 1))

# Povert ratio <= 1 with standard errors
svymean(~below_pov, svy1)
