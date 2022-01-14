# Setup
pacman::p_load('knitr', 'broom', 'Hmisc', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- age_plot ----
# Histogram
options(scipen = 999)
ggplot(df_combined, aes(x = age, weight = weight_mec)) +
  geom_histogram(aes(y = ..density..),
                 color = 'black',
                 binwidth = 2,
                 fill = 'grey') +
  stat_density(geom = 'line', aes(color = 'kernal')) +
  stat_function(fun = dnorm,
                args = list(mean = wtd.mean(df_combined$age,
                                            df_combined$weight_mec),
                            sd = sqrt(wtd.var(df_combined$age,
                                              df_combined$weight_mec))),
                aes(color = 'normal')) +
  geom_vline(aes(xintercept = svymean(~age, svy1)[1], color = 'mean'),
             size = 1,
             linetype = 'dashed') +
  geom_vline(aes(xintercept = as.numeric(svyquantile(~age,
                                                     svy1,
                                                     0.5,
                                                     ci = F)[1]),
                 color = 'median'),
             size = 1,
             linetype = 'dashed') +
  scale_color_manual(name = '',
                     values = c(kernal = 'purple',
                                normal = 'black',
                                mean = 'red',
                                median = 'blue')) +
  ggtitle('Age distribution, weighted study population') +
  theme(legend.position = 'bottom', legend.direction = 'horizontal') +
  scale_y_continuous(sec.axis = sec_axis(
    trans = ~. * sum(df_combined$weight_mec), name = 'count'))

## ---- age_stats ----
# Min, max, quantiles, and mean
svyquantile(~age, svy1, c(0, 0.25, 0.5, 0.75, 1))
svymean(~age, svy1)
