<a href="https://www.christianhicks.com" title="Homepage">Return to homepage</a>
# Effect of working hours on total blood cholesterol levels in the United States
A research project compiled by <a href="https://www.linkedin.com/in/christianjhicks/" title="LinkedIn" target="_blank">Christian Hicks</a> and advised by faculty of San Diego State University's Master of Public Health program. The datasets used in this project were obtained on October 12, 2021 from the CDC's publicly available <a href="https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2017" title="NHANES 2017-2018" target="_blank">National Health and Nutrition Examination Survey (NHANES) 2017-2018</a>.

### Table of contents
**[Directory structure](#directory-structure)**<br>
**[Introduction](#introduction)**<br>
**[Methods](#methods)**

## Directory structure

The Github repository including all original code and related files can be viewed <a href="https://github.com/hicks017/MPH-Manuscript" title="Source code" target="_blank">here</a>. The folder structure of this project is described below.
```
MPH-Manuscript             # Main directory
├── data                   # Original datafiles downloaded from the CDC's NHANES 2017-2018
├── doc                    # Documentation files
    ├── drafts             # Working drafts of the manuscript (will be deleted when writing is complete)
    ├── manuscript         # Final written report
    ├── misc               # References and formatting related files
    ├── nhanes             # Original codebooks from the CDC's NHANES 2017-2018
├── output                 # Produced files from source code (cleaned datasets, statistical analyses)
    ├── data               # Cleaned datasets
    ├── trash              # Old files preserved for edit history before Github upload date (to be be deleted)
├── src                    # Source code
    ├── bivariate          # Associations between total blood cholesterol and selected variables
    ├── exploratory        # Analysis of selected variables
    ├── trash              # Old files preserved for edit history before Github upload date (to be be deleted)
```

## Introduction

### Blood cholesterol

The NIH’s National Heart, Lung, and Blood Institute defines high cholesterol as having total blood cholesterol (TC) levels greater than or equal to 200 mg/dL.<sup><a href="https://www.nhlbi.nih.gov/health-topics/all-publications-and-resources/atp-iii-glance-quick-desk-reference" title="National Institutes of Health, 2001">1</a></sup> More than one third of the United States adult population has high TC and therefore are at a heightened risk for cardiovascular disease (CVD) and stroke .<sup><a href="https://doi.org/10.1161/CIR.0000000000000950" title="Virani et al., 2021">2</a></sup> Established risk factors of high cholesterol include obesity, lack of physical activity, diet high in saturated and trans fat, type 2 diabetes, smoking, age, gender, and familial hypercholesterolemia.<sup><a href="https://www.cdc.gov/cholesterol/risk_factors.htm" title="CDC, 2020">3</a></sup>

According to the American Heart Association’s Heart Disease and Stroke Statistics—2021 Update, adults aged 20 and older in 2015-2018 had a mean TC of 190.6 mg/dL .<sup><a href="https://doi.org/10.1161/CIR.0000000000000950" title="Virani et al., 2021">2</a></sup> Healthy People, an evidence-based initiative that sets national 10-year goals to improve the population health of the United States, chose to target a mean TC of 177.9 mg/dL by the year 2020.<sup><a href="https://www.healthypeople.gov/2020/topics-objectives/topic/heart-disease-and-stroke/objectives" title="Healthy People, 2022">4</a></sup> Therefore, the mean TC during 2015-2018 was not within the Healthy People goal for 2020. It was also estimated that 93.9 million, or 38.1%, of U.S. adults had greater than 200 mg/dL TC .<sup><a href="https://doi.org/10.1161/CIR.0000000000000950" title="Virani et al., 2021">2</a></sup> For TC greater than 240 mg/dL the estimated affected adults were 28 million, or 11.5%. Although the prevalence of high TC in adults had decreased from 18.3% in 2000 to 10.5% in 2018, the report states that the decline is likely due to greater uptake of medications rather than changes in lifestyle. The estimated economic burden of managing and preventing high cholesterol in the U.S. is between $18.5 million and $77 million every year. The estimated burden of CVD, an outcome from having high cholesterol, is $219 billion.<sup><a href="https://doi.org/10.1371/journal.pone.0254631" title="Ferrara et al., 2021">5</a></sup>

### Working hours

The U.S. Bureau of Labor Statistics reported full-time employees spent an average of 8.78 hours per workday on work or work-related activities (2019). This becomes 43.9 hours throughout a 5-day workweek. Globally, 36.1% of workers exceed 48 hours each week (Rivera et al., 2020). These numbers surpass many developed countries’ standards and recommendations. The Australian government mandates employers must not work their employees over 38 hours per week without reason (Reynolds et al., 2018). The European Union states that employers ensure their workers do not exceed an average of 48 hours per week including overtime (Your Europe, 2021). The U.S. Fair Labor and Standards Act (1938) requires overtime pay after 40 hours in a week for nonexempt employees, and there is no maximum number of hours.

When defining long working hours in research, prior studies have used various cut points such as >40 per week (Rivera et al., 2020), >80 hours per week (Lee et al., 2016), and >11 hours per day (Lemke et al., 2017). According to the U.S. Patient Protection and Affordable Care Act (2010), employees working at least 30 hours per week on average are considered full-time. Working long hours leaves less time for reaching the CDC’s guidelines of recommended exercise, diet, and sleep (Artazcoz et al., 2009). It also can expose individuals to greater amounts of work strain and psychological stress. These experiences have been shown to increase other biomarkers such as blood pressure and heart rate instability (Kivimaki & Steptoe, 2018).

### Research question

Are greater self-reported hours worked in the prior week associated with higher measurements of TC among men and women aged 18-80 years who participated in NHANES 2017-2018?

H0: There is not an association between working hours in the past week and TC.<br>
H1: There is a significant positive association between greater working hours in the past week and high TC.

## Methods

### NHANES data

The National Center for Health Statistics (NCHS) administered the National Health and Nutrition Examination Survey (NHANES) in-person to adults and adolescents in the United States during 2017 and 2018. This survey recorded cross-sectional health information and measurements for the purpose of estimating nationwide disease prevalence and aiding in health policy development. The sample design was a complex multi-level process that oversampled and undersampled certain demographics that later became weighted to represent the whole noninstitutionalized civilian population of the United States. Participants were interviewed about their personal demographics, health status, and behaviors, while measurements were recorded by a mobile clinic during a standardized physical examination.

### Study population

During 2017-2018 the National Health and Nutrition Examination Survey (NHANES) recruited 9,254 participants. Of these participants, 1,715 were selected based on their blood tests and questionnaire results. All selected observations had recorded TC measurements, at least 30 total hours worked at all jobs during the week prior to being surveyed, were not currently taking cholesterol medication, and were at least 18 years of age.

### Variables

*Outcome*: TC was recorded by a combined effort of collecting blood samples by the mobile examination clinic and enzymatic assay methods performed by contracted laboratories. Collection of the samples occurred immediately prior to questionnaire data was obtained. After the completion of the laboratory analyses, TC was recorded as discrete values with units of milligrams per deciliter (mg/dL) of blood. No parameters were placed to make exclusions based on these results.

*Exposure*: Total working hours in the week prior to the survey administration was obtained from a series of questions. First participants were asked “In this part of the survey I will ask you questions about your work experience. Which of the following were you doing last week?” The options to answer this question were as followed: Working at a job or business; with a job or business but not at work; looking for work; not working at a job or business; refused; or don’t know. Only those who responded that they worked at a job or business were considered for this study. A follow-up question was asked to those who responded as such: “How many hours did you work last week at all jobs or businesses?” Those who answered between 1 and 5 hours were recorded as “5”. Six to 78 hours were recorded as discrete values. No respondent reported 79 hours, and those who reported 80 or more were recorded as “80”. Refusals to report and “Don’t know” were also recorded. The goal of this study was to examine full-time workers, so observations were dropped from the analysis if they worked less than 30 hours, refused to report, or did not know how many hours they worked last week.

*Covariates*: Variables included in the study were chosen based on modern knowledge of risk factors related to high TC, along with common covariates of past research with similar topics. Two variables were modified from the NHANES 2017-2018 dataset to consolidate similar categories. Those who self-reported being Mexican American or Other Hispanic were collapsed into a single Hispanic category. Also, having not attended high school was combined with not finishing high school or obtaining a GED. This group was considered as No High School Diploma.

### Bias

Those who worked less than full-time in the prior week, defined as less than 30 hours, were removed from the study to prevent a potential bias that could come from observations who had not worked at all or worked very little. Children and adolescents were removed as they may not have lived long enough to observe direct effects of working hours on TC. The final model controlled for the effects of the selected covariates to measure the association more accurately between prior week working hours and TC.

### Analysis

Descriptive and analytic statistics were calculated with R 4.1.1 “Kick Things” and utilized the weights included with the NHANES 2017-2018 dataset. No unweighted statistics are listed in Tables 1-3. TC was normally distributed amongst the weighted population; therefore, the mean and standard deviation were included in Table 1. All other continuous variables were nonnormal and the medians with minimum and maximum values were reported.

Simple linear regression was used to determine the effects of the continuous variables on TC for the bivariate analysis. Pearson’s correlation was used to describe the strength of these effects. Bartlett’s test for homogeneity was used to determine the inclusion of a categorical variable in the bivariate analysis. Independent t-tests and ANOVA were performed to calculate differences in means for the included categorical variables. Multiple linear regression was used to build the adjusted model of determining the effect of prior week working hours on TC.

## Data Analysis Materials

<a href="https://hicks017.github.io/MPH-Manuscript/output/02_exploratory_3.html" title="Exploratory">Variable exploration</a>: Descriptive statistics of the independent variables included in this study.

<a href="https://hicks017.github.io/MPH-Manuscript/output/03_tableone_2.html" title="Table 1">Table 1</a>: Source of the information provided in Table 1 of the manuscript.

<a href="https://hicks017.github.io/MPH-Manuscript/output/04_bivariate_3.html" title="Bivariate">Bivariate analysis</a>: Analytic statistics of the associations between total blood cholesterol and the selected study variables.
