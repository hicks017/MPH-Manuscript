# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- sitting_reg --------
# Regression plot
plot_sit_wtd <- ggplot(df_combined,
                       aes(sitting_min_daily, bld_tc, weight = weight_mec)) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  geom_point(alpha = 0.4) +
  labs(x = 'daily sitting minutes',
       y = chol_label,
       title = 'Cholesterol by sitting minutes, weighted')

# Regression table
model_sit_wtd <- svyglm(bld_tc ~ sitting_min_daily, svy1)
model_sit_tbl_wtd <- model_sit_wtd %>% tidy(conf.int = T)
model_sit_tbl_wtd[2, 1] <- 'Sitting minutes'
model_sit_tbl_wtd$p.value <- format(model_sit_tbl_wtd$p.value, digits = 3)
model_sit_tbl_wtd <- model_sit_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + sitting_minutes',
        format = 'markdown',
        digits = 3)

# Correlation
v_sit_wtd <- svyvar(~bld_tc + sitting_min_daily, svy1, na.rm = T)
c_sit_wtd <- cov2cor(as.matrix(v_sit_wtd))[1, 2] %>% format(digits = 3)

## ---- sitting_output --------
plot_sit_wtd
model_sit_tbl_wtd