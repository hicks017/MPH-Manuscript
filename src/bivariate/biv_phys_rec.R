# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
phys_rec_vig <- as.factor(phys_rec_vig)
quant <- c(0.25, 0.5, 0.75)
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- phys_rec_tt --------
# Violin plot
plot_vig_r_wtd <- qplot(reorder(phys_rec_vig, bld_tc, median),
                        bld_tc,
                        weight = weight_mec,
                        geom = 'violin',
                        draw_quantiles = quant,
                        fill = phys_rec_vig) +
  scale_x_discrete(labels = c('Yes', 'No (reference)')) +
  theme(legend.position = 'none') +
  labs(x = 'vigorous physical recreational activity',
       y = chol_label,
       title = 'Cholesterol by response, weighted')
model_vig_r_wtd <- svyglm(bld_tc ~ relevel(as.factor(phys_rec_vig), ref = '2'),
                          svy1)
model_vig_r_tbl_wtd <- model_vig_r_wtd %>% tidy()
model_vig_r_tbl_wtd[2, 1] <- 'Yes'
model_vig_r_tbl_wtd <- model_vig_r_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + recreational_activity')

# T test
ttest_vig_r_wtd <- svyttest(bld_tc ~ phys_rec_vig, svy1)
mean_vig_r_yes_wtd <- svymean(~bld_tc, subset(svy1, phys_rec_vig == 1))
sd_vig_r_yes_wtd <- svyvar(~bld_tc, subset(svy1, phys_rec_vig == 1))[1] %>% 
  sqrt()
mean_vig_r_no_wtd <- svymean(~bld_tc, subset(svy1, phys_rec_vig == 2))
sd_vig_r_no_wtd <- svyvar(~bld_tc, subset(svy1, phys_rec_vig == 2))[1] %>% 
  sqrt()

## ---- phys_rec_output --------
plot_vig_r_wtd
model_vig_r_tbl_wtd