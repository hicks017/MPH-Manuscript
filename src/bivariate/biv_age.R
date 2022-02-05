# Setup
pacman::p_load('knitr', 'broom', 'survey', 'tidyverse', 'gridExtra')
df_combined <- readRDS('output/data/combined.Rds')
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

## ---- age_interaction ----
# No interaction observed. Results plotted below.
df_combined$age_group <- case_when(age <30 ~ 1, # 18-29
                                   age >= 30 & age < 40 ~ 2, # 30-39
                                   age >= 40 & age < 50 ~ 3, # 40-49
                                   age >= 50 & age < 60 ~ 4, # 50-59
                                   age >= 60 & age < 70 ~ 5, # 60-69
                                   age >= 70 ~ 6) # 70+
plot1 <- ggplot(subset(df_combined, age_group == 1),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 18-29')
plot2 <- ggplot(subset(df_combined, age_group == 2),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 30-39')
plot3 <- ggplot(subset(df_combined, age_group == 3),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 40-49')
plot4 <- ggplot(subset(df_combined, age_group == 4),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 50-59')
plot5 <- ggplot(subset(df_combined, age_group == 5),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 60-69')
plot6 <- ggplot(subset(df_combined, age_group == 6),
                aes(wrk_hrs, bld_tc, weight = weight_mec)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x, method = 'lm') +
  labs(x = 'work hours', y = chol_label, title = 'Age 70+')
grid.arrange(plot1, plot2, plot3, plot4, plot5, plot6)
