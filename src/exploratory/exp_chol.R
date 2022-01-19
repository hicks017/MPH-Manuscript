# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
df_male <- readRDS('./output/data/male.Rds')
df_female <- readRDS('./output/data/female.Rds')
# Cholesterol 200 mg/dL or higher
df_combined$chol200 <- ifelse(df_combined$bld_tc >= 200, 1, 0)
# Cholesterol 240 mg/dL or higher
df_combined$chol240 <- ifelse(df_combined$bld_tc >= 240, 1, 0)
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- chol_plot ----
# Histogram
options(scipen = 999)
ggplot(df_combined,
       aes(x = bld_tc, weight = weight_mec)) +
  geom_histogram(aes(y = ..density..),
                 color = 'black',
                 binwidth = 7.5,
                 fill = 'grey') +
  stat_density(geom = 'line', aes(color = 'kernal')) +
  stat_function(fun = dnorm,
                args = list(mean = wtd.mean(bld_tc, weight_mec),
                            sd = sqrt(wtd.var(bld_tc, weight_mec))),
                aes(color = 'normal')) +
  geom_vline(aes(xintercept = wtd.mean(bld_tc, weight_mec), color = 'mean'),
             size = 1,
             linetype = 'dashed') +
  geom_vline(aes(xintercept = wtd.quantile(bld_tc, weight_mec, 0.5),
                 color = 'median'),
             size = 1,
             linetype = 'dashed') +
  scale_color_manual(name = '',
                     values = c(kernal = 'purple',
                                normal = 'black',
                                mean = 'red',
                                median = 'blue')) +
  ggtitle('Blood Cholesterol distribution') +
  theme(legend.position = 'bottom', legend.direction = 'horizontal') +
  scale_y_continuous(sec.axis = sec_axis(
    trans = ~. * sum(weight_mec), name = 'count')) +
  xlab('total cholesterol (mg/dL)')

## ---- chol_stats ----
# Min, max, quantiles, and mean
svyquantile(~bld_tc, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~bld_tc, svy1)

# Proportion of 200 mg/dL and over, 240 mg/dL and higher
svymean(~chol200 + chol240, svy1)

# Gender stratification, mean TC
wtd.mean(df_male$bld_tc, weights = df_male$weight_mec)
wtd.mean(df_female$bld_tc, weights = df_female$weight_mec)
