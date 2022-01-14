# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- bmi_reg --------
# Regression plot
plot_bmi_wtd <- ggplot(df_combined, aes(bmi, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'BMI', y = chol_label, title = 'Cholesterol by BMI, weighted')

# Regression table
model_bmi_wtd <- svyglm(bld_tc ~ bmi, svy1)
model_bmi_tbl_wtd <- model_bmi_wtd %>% tidy(conf.int = T)
model_bmi_tbl_wtd[2, 1] <- 'BMI'
model_bmi_tbl_wtd$p.value <- format(model_bmi_tbl_wtd$p.value, digits = 3)
model_bmi_tbl_wtd <- model_bmi_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + bmi',
        format = 'markdown',
        digits = 3)

# Correlation
v_bmi_wtd <- svyvar(~bld_tc + bmi, svy1, na.rm = T)
c_bmi_wtd <- cov2cor(as.matrix(v_bmi_wtd))[1, 2] %>% format(digits = 3)

## ---- bmi_output --------
plot_bmi_wtd
model_bmi_tbl_wtd