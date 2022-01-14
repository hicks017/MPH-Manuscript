# Required packages
pacman::p_load('haven', 'naniar', 'data.table', 'tidyverse')


# Table of Contents -------------------------------------------------------

#   1.  Import Data
#   2.  Flow Chart
#   3.  Recode, Rename, and Drop
#   4.  Missing numbers
#   5.  Subset and Save


# Import Data --------------------------------------------------

# Import original datasets
# Overall n = 9254
# Lab participant n = 7435
df_tot_chol <- read_xpt('./data/TCHOL_J.XPT')
df_work <- read_xpt('./data/OCQ_J.XPT')
df_question_chol <- read_xpt('./data/BPQ_J.XPT')
df_phys <- read_xpt('./data/PAQ_J.XPT')
df_body <- read_xpt('./data/BMX_J.XPT')
df_dem <-  read_xpt('./data/DEMO_J.XPT')

# Flow Chart --------------------------------------------------------------

# Drop lab ID's with no lab data.
# removed = 697; n = 6738
df_tot_chol <- df_tot_chol[complete.cases(df_tot_chol[ , 2]),]

# Join lab data with occupation data. Drops non-shared IDs.
# Shared IDs with coded NA occupation data remain and will be removed later.
# removed = 1292; n = 5446
df_work <- df_work %>% 
  replace_with_na(list(OCQ180 = c(77777, 99999))) # Refused and Don't Know
df_combined <- df_tot_chol %>% inner_join(df_work, by = 'SEQN')

# Add data from questionnaire, physical activity, and demographic datasets
# Left join prevents removal of IDs from df_combined
# removed = 0; n = 5446
df_combined <- df_combined %>% left_join(df_question_chol, by = 'SEQN')
df_combined <- df_combined %>% left_join(df_phys, by = 'SEQN')
df_combined <- df_combined %>% left_join(df_dem, by = 'SEQN')
df_combined <- df_combined %>% left_join(df_body, by = 'SEQN')

# Remove observations currently taking cholesterol medication
# removed = 1072; n = 4374
df_combined <- df_combined %>% subset(BPQ100D != 1 | is.na(BPQ100D))

# Subset to at least 30 hours worked. NAs are removed.
# removed = 2389; n = 1985
df_combined <- df_combined %>% subset(OCQ180 >= 30)

# Subset to participants 18 years of age and older
# removed = 14; n = 1971
df_combined <- df_combined %>% subset(RIDAGEYR >= 18)

## Subset to remove observations with NA values for variables in the final model
# removed = 256, n = 1,715
df_combined <- df_combined %>% subset(BMXBMI >= 0 & INDFMPIR >= 0)

# Rename, Recode, and Drop ------------------------------------------------

# Renaming variables
# new_name = old_name
df_combined <- df_combined %>% 
  rename(wrk_hrs = OCQ180,
         bld_tc = LBXTC,
         chol_doctor_hi = BPQ080,
         chol_checked_ever = BPQ060, # 359 missing
         chol_checked_last = BPQ070, # 582 missing
         chol_doctor_rx = BPQ090D, # 582 missing
         chol_taking_rx = BPQ100D, # 1822 missing
         phys_work_vig = PAQ605,
         phys_work_mod = PAQ620,
         phys_rec_vig = PAQ650,
         phys_rec_mod = PAQ665,
         sitting_min_daily = PAD680, # 2 missing
         gender = RIAGENDR,
         age = RIDAGEYR,
         race_eth = RIDRETH3,
         education = DMDEDUC2, # 55 missing
         marital = DMDMARTL, # 55 missing
         income_family = INDFMIN2, # 93 missing
         income_pov_ratio = INDFMPIR, # 246 missing, more than 10% of study pop
         bmi = BMXBMI, # 17 missing
         weight_mec = WTMEC2YR)

# Replace with NA
# 7s: Refused to answer
# 9s: Don't know
df_combined <- df_combined %>% 
  replace_with_na(list(sitting_min_daily = c(9999))) # Sitting; 2 observations
df_combined <- df_combined %>% 
  replace_with_na(list(education = c(7, 9))) # Education; 1 observation of each
df_combined <- df_combined %>% 
  replace_with_na(
    list(phys_work_vig = 9) # Vigorous work activity; 1 observation
  )
df_combined <- df_combined %>% 
  replace_with_na(
    list(chol_doctor_hi = 9) # Doctor says high cholesterol; 7 observations
  )

# Recode gender from (1 = male, 2 = female) to (0 = female, 1 = male)
df_combined$gender <- ifelse(df_combined$gender == 2, 0, 1)

# Recode race/ethnic (combining two categories into 'Hispanic')
# Mexican American (1)
# Other Hispanic (2)
df_combined$race_eth <- case_when(df_combined$race_eth == 1 ~ 1,
                                  df_combined$race_eth == 2 ~ 1,
                                  df_combined$race_eth == 3 ~ 3,
                                  df_combined$race_eth == 4 ~ 4,
                                  df_combined$race_eth == 6 ~ 6,
                                  df_combined$race_eth == 7 ~ 7)

# Recode education (combining two categories that are lower than HS degree)
# Less than 9th grade (1)
# Incomplete HS (2)
df_combined$education <- case_when(df_combined$education == 1 ~ 1,
                                   df_combined$education == 2 ~ 1,
                                   df_combined$education == 3 ~ 3,
                                   df_combined$education == 4 ~ 4,
                                   df_combined$education == 5 ~ 5)

# Drop unused variables
my_vars <- c(
  'SEQN',
  'bld_tc',
  'wrk_hrs',
  'chol_doctor_hi',
  'phys_work_vig',
  'phys_rec_vig',
  'sitting_min_daily',
  'gender',
  'age',
  'race_eth',
  'education',
  'income_pov_ratio',
  'bmi',
  'weight_mec')
df_combined <- df_combined %>% select(c(all_of(my_vars)))

# Missing numbers reported in above comments
colSums(is.na(df_combined)) %>% as.data.frame()

# Subset and Save ---------------------------------------------------------

# Subset males and females
df_male <- df_combined %>% subset(gender == 1)
df_female <- df_combined %>% subset(gender == 0)

# Permanently save datasets
saveRDS(df_combined, './output/data/combined.Rds')
saveRDS(df_male, './output/data/male.Rds')
saveRDS(df_female, './output/data/female.Rds')
