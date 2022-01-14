pacman::p_load('tidyverse', 'tableone')

# Loading permanent datasets
df_male <- readRDS('./output/data/male.Rds')
df_female <- readRDS('./output/data/female.Rds')

# Table 1 Stratified variables
table1_vars_gender <- c(
  'bld_tc',
  'wrk_hrs',
  'phys_work_vig',
  'phys_rec_vig',
  'sitting_min_daily',
  'chol_doctor_hi',
  'chol_taking_rx',
  'age',
  'bmi',
  'race_eth',
  'education',
  'income_pov_ratio'
)
table1_cats_gender <- c(
  'phys_work_vig',
  'phys_rec_vig',
  'chol_doctor_hi',
  'chol_taking_rx',
  'race_eth',
  'education'
)

################################################################################
# MALE STRATIFIED TABLE 1 ######################################################

# Checking missingness
colSums(is.na(df_male)) %>% as.data.frame()

# Table output
table_1_male <- CreateTableOne(
  vars = table1_vars_gender,
  data = df_male,
  factorVars = table1_cats_gender
  )
table_1_male
################################################################################



################################################################################
# FEMALE STRATIFIED TABLE 1 ####################################################

# Checking missingness
colSums(is.na(df_female)) %>% as.data.frame()

# Table output
table_1_female <- CreateTableOne(
  vars = table1_vars_gender,
  data = df_female,
  factorVars = table1_cats_gender
  )
table_1_female
################################################################################