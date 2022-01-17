# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
chol_doctor_hi <- as.factor(chol_doctor_hi)
quant <- c(0.25, 0.5, 0.75)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- doctor_tt --------
# Violin plot
plot_doc_wtd <- qplot(reorder(chol_doctor_hi, bld_tc, median), bld_tc,
                      weight = weight_mec,
                      geom = 'violin',
                      draw_quantiles = quant,
                      fill = chol_doctor_hi) +
  theme(legend.position = 'none') +
  scale_x_discrete(labels = c('No (reference)', 'Yes')) +
  labs(x = 'doctor says cholesterol is high',
       y = chol_label,
       title = 'Cholesterol by response, weighted')
model_doc_wtd <- svyglm(bld_tc ~ relevel(as.factor(chol_doctor_hi), ref = '2'), 
                        svy1)
model_doc_tbl_wtd <- model_doc_wtd %>% tidy()
model_doc_tbl_wtd[2, 1] <- 'Yes'
model_doc_tbl_wtd <- model_doc_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + doctor_opinion',
        format = 'markdown', digits = c(3, 3, 3, 3, 4))

# ANOVA
anova_doc_wtd <- aov(bld_tc ~ chol_doctor_hi, weights = weight_mec)
pw_doc_wtd <- pairwise.t.test(bld_tc, chol_doctor_hi,
                              weights = weight_mec,
                              p.adjust.method = 'bonf') %>% 
  tidy()
pw_doc_wtd[1, 1] <- 'No'
pw_doc_wtd[1, 2] <- 'Yes'
pw_doc_wtd[2, 1] <- 'Does not know'
pw_doc_wtd[2, 2] <- 'Yes'
pw_doc_wtd[3, 1] <- 'Does not know'
pw_doc_wtd[3, 2] <- 'No'
mean_doc_yes_wtd <- svymean(~bld_tc, subset(svy1, chol_doctor_hi == 1))
sd_doc_yes_wtd <- svyvar(~bld_tc, subset(svy1, chol_doctor_hi == 1))[1] %>% 
  sqrt()
mean_doc_no_wtd <- svymean(~bld_tc, subset(svy1, chol_doctor_hi == 2))
sd_doc_no_wtd <- svyvar(~bld_tc, subset(svy1, chol_doctor_hi == 2))[1] %>% 
  sqrt()
mean_doc_dont_wtd <- svymean(~bld_tc, subset(svy1, chol_doctor_hi == 9))
sd_doc_dont_wtd <- svyvar(~bld_tc, subset(svy1, chol_doctor_hi == 9))[1] %>% 
  sqrt()

## ---- doctor_output --------
plot_doc_wtd
model_doc_tbl_wtd