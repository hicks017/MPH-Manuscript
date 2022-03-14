# Copied code from original data cleaning file
pacman::p_load("haven", "naniar", "broom", "Hmisc", "survey", "tidyverse")
df_tot_chol <- read_xpt("data/TCHOL_J.XPT")
df_work <- read_xpt("data/OCQ_J.XPT")
df_question_chol <- read_xpt("data/BPQ_J.XPT")
df_phys <- read_xpt("data/PAQ_J.XPT")
df_body <- read_xpt("data/BMX_J.XPT")
df_dem <-  read_xpt("data/DEMO_J.XPT")
df_tot_chol <- df_tot_chol[complete.cases(df_tot_chol[ , 2]),]
df_work <- df_work %>% 
  replace_with_na(list(OCQ180 = c(77777, 99999)))
df_post_hoc <- df_tot_chol %>% inner_join(df_work, by = "SEQN")
df_post_hoc <- df_post_hoc %>% 
  left_join(., df_question_chol, by = "SEQN") %>%
  left_join(., df_phys, by = "SEQN") %>%
  left_join(., df_dem, by = "SEQN") %>% 
  left_join(., df_body, by = "SEQN")
df_post_hoc <- df_post_hoc %>% subset(BPQ100D != 1 | is.na(BPQ100D))

# Switching working hours to less than 30
df_post_hoc <- df_post_hoc %>% subset(OCQ180 < 30 | is.na(OCQ180))

# Continuing copied code
df_post_hoc <- df_post_hoc %>% subset(RIDAGEYR >= 18)
df_post_hoc <- df_post_hoc %>% subset(BMXBMI >= 0 & INDFMPIR >= 0)
df_post_hoc <- df_post_hoc %>% 
  rename(wrk_hrs = OCQ180,
         bld_tc = LBXTC,
         chol_doctor_hi = BPQ080,
         chol_checked_ever = BPQ060,
         chol_checked_last = BPQ070,
         chol_doctor_rx = BPQ090D,
         chol_taking_rx = BPQ100D,
         phys_work_vig = PAQ605,
         phys_work_mod = PAQ620,
         phys_rec_vig = PAQ650,
         phys_rec_mod = PAQ665,
         sitting_min_daily = PAD680,
         gender = RIAGENDR,
         age = RIDAGEYR,
         race_eth = RIDRETH3,
         education = DMDEDUC2,
         marital = DMDMARTL,
         income_family = INDFMIN2,
         income_pov_ratio = INDFMPIR,
         bmi = BMXBMI,
         weight_mec = WTMEC2YR)
df_post_hoc <- df_post_hoc %>% 
  replace_with_na(list(sitting_min_daily = c(9999),
                       education = c(7, 9),
                       phys_work_vig = 9,
                       chol_doctor_hi = 9))
df_post_hoc$gender <- ifelse(df_post_hoc$gender == 2, 0, 1)
df_post_hoc$race_eth[df_post_hoc$race_eth == 2] <- 1
df_post_hoc$education[df_post_hoc$education == 2] <- 1
my_vars <- c(
  "SEQN",
  "bld_tc",
  "wrk_hrs",
  "chol_doctor_hi",
  "phys_work_vig",
  "phys_rec_vig",
  "sitting_min_daily",
  "gender",
  "age",
  "race_eth",
  "education",
  "income_pov_ratio",
  "bmi",
  "weight_mec")
df_post_hoc <- df_post_hoc %>% select(c(all_of(my_vars)))

# Begin post-hoc analysis of healthy worker effect -----------------------------
df_post_hoc$chol200 <- ifelse(df_post_hoc$bld_tc >= 200, 1, 0)
df_post_hoc$chol240 <- ifelse(df_post_hoc$bld_tc >= 240, 1, 0)
attach(df_post_hoc)
svy1 <- svydesign(ids = SEQN,
                  weights = weight_mec,
                  data = df_post_hoc)
# High and very high cholesterol prevalence
svymean(~chol200 + chol240, svy1)

# Did not work prevalence
mean(is.na(df_post_hoc$wrk_hrs))

# Stacking the two datasets to later compare
df_post_hoc <- mutate(df_post_hoc, group = 0)
df_combined <- readRDS("output/data/combined.Rds")
df_combined$chol200 <- ifelse(df_combined$bld_tc >= 200, 1, 0)
df_combined$chol240 <- ifelse(df_combined$bld_tc >= 240, 1, 0)
df_combined <- mutate(df_combined, group = 1)
df_both <- full_join(df_post_hoc, df_combined)
svy2 <- svydesign(ids = ~SEQN,
                  weights = ~weight_mec,
                  data = df_both)

# Comparing with t tests
data.frame(under30 = wtd.mean(df_post_hoc$chol200, df_post_hoc$weight_mec),
           full_time = wtd.mean(df_combined$chol200, df_combined$weight_mec),
           row.names = "chol200_prev")
svyttest(chol200 ~ group, svy2) %>% tidy()
data.frame(under30 = wtd.mean(df_post_hoc$chol240, df_post_hoc$weight_mec),
           full_time = wtd.mean(df_combined$chol240, df_combined$weight_mec),
           row.names = "chol240_prev")
svyttest(chol240 ~ group, svy2) %>% tidy()
data.frame(under30 = wtd.mean(df_post_hoc$bld_tc, df_post_hoc$weight_mec),
           full_time = wtd.mean(df_combined$bld_tc, df_combined$weight_mec),
           row.names = "TC")
svyttest(bld_tc ~ group, svy2) %>% tidy()
