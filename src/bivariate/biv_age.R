# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- age_reg ----
# Regression plot
plot_age_wtd <- ggplot(df_combined, aes(age, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'age', y = chol_label, title = 'Cholesterol by age, weighted')

# Regression table
model_age_wtd <- svyglm(bld_tc ~ age, svy1)
model_age_tbl_wtd <- model_age_wtd %>% tidy(conf.int = T)
model_age_tbl_wtd[2, 1] <- 'Age'
model_age_tbl_wtd$p.value <- format(model_age_tbl_wtd$p.value, digits = 3)
model_age_tbl_wtd <- model_age_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + age',
        format = 'markdown',
        digits = 3)

# Correlation
v_age_wtd <- svyvar(~bld_tc + age, svy1)
c_age_wtd <- cov2cor(as.matrix(v_age_wtd))[1, 2] %>% format(digits = 3)

## ---- age_output ----
plot_age_wtd
model_age_tbl_wtd