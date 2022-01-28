# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('output/data/combined.Rds')
df_combined$bmi25 <- ifelse(df_combined$bmi >= 25, 1, 0) # BMI over 25
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- bmi_plot ----
# Histogram
options(scipen = 999)
ggplot(df_combined, aes(x = bmi, weight = weight_mec)) +
  geom_histogram(aes(y = ..density..),
                 color = 'black',
                 binwidth = 2,
                 fill = 'grey') +
  stat_density(geom = 'line', aes(color = 'kernal')) +
  stat_function(fun = dnorm,
                args = list(mean = wtd.mean(bmi, weight_mec),
                            sd = sqrt(wtd.var(bmi, weight_mec))),
                aes(color = 'normal')) +
  geom_vline(aes(xintercept = wtd.mean(bmi, weight_mec), color = 'mean'),
             size = 1,
             linetype = 'dashed') +
  geom_vline(aes(xintercept = wtd.quantile(bmi, weight_mec, 0.5),
                 color = 'median'),
             size = 1,
             linetype = 'dashed') +
  scale_color_manual(name = '',
                     values = c(kernal = 'purple',
                                normal = 'black',
                                mean = 'red',
                                median = 'blue')) +
  ggtitle('BMI distribution, weighted study population') +
  theme(legend.position = 'bottom', legend.direction = 'horizontal') +
  scale_y_continuous(sec.axis = sec_axis(
    trans = ~. * sum(weight_mec), name = 'count'))

## ----bmi_stats ----
# Min, max, quantiles, and mean
svyquantile(~bmi, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~bmi, svy1)

# Proportion of 25 or greater BMI
svymean(~bmi25, svy1)
