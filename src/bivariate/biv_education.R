# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
education <- as.factor(education)
quant <- c(0.25, 0.5, 0.75)
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- education_anova --------
# Violin plot
plot_edu_wtd <- qplot(reorder(education, bld_tc, median),
                      bld_tc,
                      data = subset(df_combined, !is.na(education)),
                      weight = weight_mec,geom = 'violin',
                      draw_quantiles = quant,
                      fill = as.factor(education)) +
  scale_x_discrete(labels = c('Some college',
                              'H.S./GED (reference)',
                              'College graduate',
                              'No H.S. diploma')) +
  theme(legend.position = 'none') +
  labs(x = 'education',
       y = chol_label,
       title = 'Cholesterol by education, weighted')
model_edu_wtd <- svyglm(bld_tc ~ relevel(as.factor(education), ref = '3'), 
                        svy1)
model_edu_tbl_wtd <- model_edu_wtd %>% tidy()
model_edu_tbl_wtd[2, 1] <- 'No H.S. diploma'
model_edu_tbl_wtd[3, 1] <- 'Some college'
model_edu_tbl_wtd[4, 1] <- 'College graduate'
model_edu_tbl_wtd <- model_edu_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + education')

# ANOVA
anova_edu_wtd <- aov(bld_tc ~ education, weights = weight_mec)
mean_edu_1_wtd <- svymean(~bld_tc, subset(svy1, education == 1))
sd_edu_1_wtd <- svyvar(~bld_tc, subset(svy1, education == 1))[1] %>% 
  sqrt()
mean_edu_3_wtd <- svymean(~bld_tc, subset(svy1, education == 3))
sd_edu_3_wtd <- svyvar(~bld_tc, subset(svy1, education == 3))[1] %>% 
  sqrt()
mean_edu_4_wtd <- svymean(~bld_tc, subset(svy1, education == 4))
sd_edu_4_wtd <- svyvar(~bld_tc, subset(svy1, education == 4))[1] %>% 
  sqrt()
mean_edu_5_wtd <- svymean(~bld_tc, subset(svy1, education == 5))
sd_edu_5_wtd <- svyvar(~bld_tc, subset(svy1, education == 5))[1] %>% 
  sqrt()

## ---- education_output --------
plot_edu_wtd
model_edu_tbl_wtd