# Required packages
pacman::p_load('haven', 'naniar', 'data.table', 'tidyverse')

# Import original datasets
# Overall n = 9254
# Lab participant n = 7435
df_tot_chol <- read_xpt('./data/TCHOL_J.XPT')
df_work <- read_xpt('./data/OCQ_J.XPT')
df_question_chol <- read_xpt('./data/BPQ_J.XPT')
df_phys <- read_xpt('./data/PAQ_J.XPT')
df_body <- read_xpt('./data/BMX_J.XPT')
df_dem <-  read_xpt('./data/DEMO_J.XPT')

# Subset to relevant variables
# SEQN: participant ID
# LBXTC: Total cholesterol (mg/dL)
# OCQ180: Hours worked last week
# BPQ080: Doctor ever said high cholesterol
# BPQ060: Ever had cholesterol checked
# BPQ070: When cholesterol last checked
# BPQ090D: Told to take medication
# BPQ100D: Now taking medication
df_tot_chol <- df_tot_chol %>% select(SEQN, LBXTC)
df_work <- df_work %>% select(SEQN, OCQ180)
df_question_chol <- df_question_chol %>% 
  select(
    SEQN,
    BPQ080,
    BPQ060,
    BPQ070,
    BPQ090D,
    BPQ100D
  )
df_body <- df_body %>% select(SEQN, BMXBMI)

# Replace with NA
# 7s: Refused to answer
# 9s: Don't know
df_work <- df_work %>% 
  replace_with_na(
    list(OCQ180 = c(77777, 99999))
  )
df_phys <- df_phys %>% 
  replace_with_na(
    list(PAD680 = c(7777, 9999))
  )

# Drop lab ID's with no lab data.
# removed = 697; n = 6738
df_tot_chol <- df_tot_chol[complete.cases(df_tot_chol[ , 2]),]

# Join lab data with occupation data. Drops non-shared IDs.
# Shared IDs with coded NA occupation data remain and will be removed later.
# removed = 1292; n = 5446
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

# Recode gender from (1 = male, 2 = female) to (0 = female, 1 = male)
df_combined$RIAGENDR <- ifelse(df_combined$RIAGENDR == 2, 0, 1)
# Renaming variables
# new_name = old_name
df_combined <- df_combined %>% rename(
  wrk_hrs = OCQ180,
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
  sitting_min_daily = PAD680, # 4 missing
  gender = RIAGENDR,
  age = RIDAGEYR,
  race_eth = RIDRETH3,
  education = DMDEDUC2, # 55 missing
  marital = DMDMARTL, # 55 missing
  income_family = INDFMIN2, # 93 missing
  income_pov_ratio = INDFMPIR, # 246 missing, more than 10% of study pop
  bmi = BMXBMI, # 17 missing
  weight_mec = WTMEC2YR
)
attach(df_combined)

# Drop unused variables
my_vars <- c(
  'SEQN',
  'wrk_hrs',
  'bld_tc',
  'chol_doctor_hi',
  'chol_checked_ever',
  'chol_checked_last',
  'chol_doctor_rx',
  'chol_taking_rx',
  'phys_work_vig',
  'phys_work_mod',
  'phys_rec_vig',
  'phys_rec_mod',
  'sitting_min_daily',
  'gender',
  'age',
  'race_eth',
  'education',
  'marital',
  'income_family',
  'income_pov_ratio',
  'bmi',
  'weight_mec'
)
df_combined <- df_combined %>% select(c(all_of(my_vars)))

# Missing numbers reported in above comments
colSums(is.na(df_combined)) %>% as.data.frame()

# Subset males and females
df_male <- df_combined %>% subset(gender == 1)
df_female <- df_combined %>% subset(gender == 0)

# Permanently save datasets
saveRDS(df_combined, './output/data/combined.Rds')
saveRDS(df_male, './output/data/male.Rds')
saveRDS(df_female, './output/data/female.Rds')
fwrite(df_combined, './output/data/combined.csv')
fwrite(df_male, './output/data/male.csv')
fwrite(df_female, './output/data/female.csv')
