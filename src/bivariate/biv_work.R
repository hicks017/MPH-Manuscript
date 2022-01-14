# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse')
df_combined <- readRDS('./output/data/combined.Rds')
attach(df_combined)
chol_label <- 'total cholesterol (mg/dL)'
# Weighted data
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_combined)

## ---- wrk_reg --------
# Regression plot
plot_wrk_wtd <- ggplot(df_combined, aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'working hours',
       y = chol_label,
       title = 'Cholesterol by working hours, weighted')

# Regression table
model_wrk_wtd <- svyglm(bld_tc ~ wrk_hrs, svy1)
model_wrk_tbl_wtd <- model_wrk_wtd %>% tidy(conf.int = T)
model_wrk_tbl_wtd[2, 1] <- 'Working hours'
model_wrk_tbl_wtd <- model_wrk_tbl_wtd %>% 
  kable(caption = 'Model: total cholesterol = int + working hours',
        format = 'markdown', digits = 3)

# Correlation
v_wrk_wtd <- svyvar(~bld_tc + wrk_hrs, svy1)
c_wrk_wtd <- cov2cor(as.matrix(v_wrk_wtd))[1, 2] %>% format(digits = 3)

## ---- wrk_hrs_output --------
plot_wrk_wtd
model_wrk_tbl_wtd