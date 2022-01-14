# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
gender <- as.factor(gender)
quant <- c(0.25, 0.5, 0.75)
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- gender_tt --------
# Violin plot
plot_gender_wtd <- qplot(gender,
                         bld_tc,
                         weight = weight_mec,
                         geom = 'violin',
                         draw_quantiles = quant,
                         fill = gender) +
  scale_x_discrete(labels = c('female', 'male')) +
  scale_fill_manual(values = c('lightpink', 'lightblue')) +
  theme(legend.position = 'none') +
  labs(x = 'gender',
       y = chol_label,
       title = 'Cholesterol by gender, weighted')
# Female is reference; CDC states they have lower LDL and higher HDL
model_gender_wtd <- svyglm(bld_tc ~ gender, svy1)
model_gender_tbl_wtd <- model_gender_wtd %>% tidy(conf.int = T)
model_gender_tbl_wtd[2, 1] <- 'Male'
model_gender_tbl_wtd <- model_gender_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + gender',
        format = 'markdown', digits = 3)
# T test
ttest_gen_wtd <- svyttest(bld_tc ~ gender, svy1)
mean_gen_f_wtd <- svymean(~bld_tc, subset(svy1, gender == 0))
sd_gen_f_wtd <- svyvar(~bld_tc, subset(svy1, gender == 0))[1] %>% sqrt()
mean_gen_m_wtd <- svymean(~bld_tc, subset(svy1, gender == 1))
sd_gen_m_wtd <- svyvar(~bld_tc, subset(svy1, gender == 1))[1] %>% sqrt()

## ---- gender_output --------
plot_gender_wtd
model_gender_tbl_wtd