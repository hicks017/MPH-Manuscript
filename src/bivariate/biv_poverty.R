# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
# Weighted data
svy1 <- svydesign(ids = df_combined$SEQN,
                  weights = df_combined$weight_mec,
                  data = df_combined)

## ---- poverty_reg --------
# Regression plot
plot_pov_wtd <- ggplot(df_combined,
                       aes(income_pov_ratio, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'income to poverty ratio',
       y = chol_label,
       title = 'Cholesterol by poverty ratio, weighted')

# Regression table
model_pov_wtd <- svyglm(bld_tc ~ income_pov_ratio, svy1)
model_pov_tbl_wtd <- model_pov_wtd %>% tidy(conf.int = T)
model_pov_tbl_wtd[2, 1] <- 'Income to poverty ratio'
model_pov_tbl_wtd$p.value <- format(model_pov_tbl_wtd$p.value, digits = 3)
model_pov_tbl_wtd <- model_pov_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + poverty_ratio')

# Correlation
v_pov_wtd <- svyvar(~bld_tc + income_pov_ratio, svy1, na.rm = T)
c_pov_wtd <- cov2cor(as.matrix(v_pov_wtd))[1, 2] %>% format(digits = 4)

## ---- poverty_output --------
plot_pov_wtd
model_pov_tbl_wtd