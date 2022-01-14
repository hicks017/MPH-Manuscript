# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
race_eth <- as.factor(race_eth)
quant <- c(0.25, 0.5, 0.75)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- race_anova --------
# Violin plot
plot_race_wtd <- qplot(reorder(race_eth, bld_tc, median), bld_tc,
                       weight = weight_mec,
                       geom = 'violin',
                       draw_quantiles = quant,
                       fill = race_eth) +
  scale_x_discrete(labels = c('Black',
                              'White (reference)',
                              'Hispanic',
                              'Other or Multi',
                              'Asian')) +
  theme(legend.position = 'none') +
  labs(x = 'race/ethnicity',
       y = chol_label,
       title = 'Cholesterol by race/ethnicity, weighted')
model_race_wtd <- svyglm(bld_tc ~ relevel(as.factor(race_eth), ref = '3'), 
                         svy1)
model_race_tbl_wtd <- model_race_wtd %>% tidy()
model_race_tbl_wtd[2, 1] <- 'Hispanic'
model_race_tbl_wtd[3, 1] <- 'Non-Hispanic Black'
model_race_tbl_wtd[4, 1] <- 'Non-Hispanic Asian'
model_race_tbl_wtd[5, 1] <- 'Other race or Multi-Racial'
model_race_tbl_wtd <- model_race_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + race')

# ANOVA
anova_race_wtd <- aov(bld_tc ~ race_eth, weights = weight_mec)
pw_race_wtd <- pairwise.t.test(bld_tc, race_eth,
                               weights = weight_mec,
                               p.adjust.method = 'bonf') %>% 
  tidy()
mean_race_1_wtd <- svymean(~bld_tc, subset(svy1, race_eth == 1))
sd_race_1_wtd <- svyvar(~bld_tc, subset(svy1, race_eth == 1))[1] %>% 
  sqrt()
mean_race_3_wtd <- svymean(~bld_tc, subset(svy1, race_eth == 3))
sd_race_3_wtd <- svyvar(~bld_tc, subset(svy1, race_eth == 3))[1] %>% 
  sqrt()
mean_race_4_wtd <- svymean(~bld_tc, subset(svy1, race_eth == 4))
sd_race_4_wtd <- svyvar(~bld_tc, subset(svy1, race_eth == 4))[1] %>% 
  sqrt()
mean_race_6_wtd <- svymean(~bld_tc, subset(svy1, race_eth == 6))
sd_race_6_wtd <- svyvar(~bld_tc, subset(svy1, race_eth == 6))[1] %>% 
  sqrt()
mean_race_7_wtd <- svymean(~bld_tc, subset(svy1, race_eth == 7))
sd_race_7_wtd <- svyvar(~bld_tc, subset(svy1, race_eth == 7))[1] %>% 
  sqrt()

## ---- race_output --------
plot_race_wtd
model_race_tbl_wtd