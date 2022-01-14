pacman::p_load('tidyverse', 'tableone')

# Loading permanent datasets
df_combined <- readRDS('./output/data/combined.Rds')

# Checking missingness
colSums(is.na(df_combined)) %>% as.data.frame()

# Table 1 variables
table1_vars <- c(
  'bld_tc',
  'wrk_hrs',
  'phys_work_vig',
  'phys_rec_vig',
  'sitting_min_daily',
  'chol_doctor_hi',
  'chol_taking_rx',
  'gender',
  'age',
  'bmi',
  'race_eth',
  'education',
  'income_pov_ratio'
)
table1_cats <- c(
  'phys_work_vig',
  'phys_rec_vig',
  'chol_doctor_hi',
  'chol_taking_rx',
  'gender',
  'race_eth',
  'education'
)

# Total Population Table
table_1 <- CreateTableOne(vars = table1_vars, data = df_combined, factorVars = table1_cats)
table_1
