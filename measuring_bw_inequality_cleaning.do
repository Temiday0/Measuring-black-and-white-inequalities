*=============================================================================

* This do-file creates a dataset on black-white earnings gaps over 1950-2019 
* at the median (and 90th percentile) controlling for age groups.

*=============================================================================
* 1. Setting directories.
*=============================================================================

* Designate directories for project, data, figures

clear all
global project 	"/Users/user/Desktop/Measuring_bw_inequalilty"
global code 	"${project}/code"
global data 	"${project}/data"
global figures 	"${project}/figures"
global output 	"${project}/output"
cd "${project}"


*=============================================================================
* 2. Generating and preparing variables for analysis.
*=============================================================================

* Loaded in 5% sample data
use "${data}/5_percent_sample.dta"

* Sampling criteria - limited to ages 25-54
*drop if age < 25 | age > 54


* Adjusted income variables given changing definitions over time 
* Replaced observations with inconsistent wage
drop if incwage >= 999998
*replace incbusfm = . if incbusfm == 99999
replace incbusfm = 0 if incbusfm < 0
*replace incbus = . if incbus == 999999
replace incbus = 0 if incbus < 0
*replace incfarm = . if incfarm == 999999
replace incfarm = 0 if incfarm < 0
*replace incbus00 = . if incbus00 == 999999
replace incbus00 = 0 if incbus00 < 0


*Adjust income variables given changing definitions over time 
replace incwage  = 1.2 * incwage if ind1950 == 105
replace incbusfm = 1.4 * incbusfm if ind1950 == 105 & year <= 1960
replace incbusfm = incbus + 1.4 * incfarm if year >= 1970 & year <= 1990
replace incbusfm = incbus00 if year >= 2000
replace incbusfm = 1.4 * incbus00 if year >= 2000 & ind1950 == 105


*Sum up income
cap generate inc = incwage + incbusfm 
replace  inc = incwage if inc == .


*merge in inflation numbers
merge m:1 year using "${data}/cpi_acs.dta"
keep if inlist(year,1950,1960,1970,1980,1990,2000,2007,2010,2014,2019)
drop _merge


* adjust to real 2019 dollars
*gen real_earnings = inc * (376.5/CPI_1977)


* Created samples dummies for 3 different figures
* Sample1: for working men only
* Sample2: for all men
* Sample3: for all men & women
cap generate sample1 = 0
cap generate sample2 = 0
cap generate sample3 = 0
replace  sample1 = 1 if sex==1 & real_earnings>1
replace  sample2 = 1 if sex==1
replace  sample3 = 1

* log real earnings
cap gen logrealearn = log(real_earnings + 1)


* Genrate age controls
* Baseline age group is omitted to avoid multicollinearity
*gen ageg1 = age > 24 & age < 30
cap gen ageg2 = age > 29 & age < 35
cap gen ageg3 = age > 34 & age < 40
cap gen ageg4 = age > 39 & age < 45
cap gen ageg5 = age > 44 & age < 50
cap gen ageg6 = age > 49 & age < 55
cap drop age


* racial dummy variables
cap gen black = race == 2 & hispan == 0, replace
cap gen white = race == 1 & hispan == 0, replace
cap gen other = black == 0 & white == 0, replace


* racial category variable
cap gen 	race_string = "Other"
replace race_string = "Black" if race==2
replace race_string = "White" if race==1



*The following codes below ran using R. I highlight it as text, so this do file can easily run without breaking

/*
Quat_Reg <- merged_data %>%
  rq(
    formula = logrealearn ~ black,
    data = .,
    tau = 0.5
  )


Quant_reg <- merged_data %>% filter(sample3 == 1) %>% filter(year == 1950) %>% 
  rq(
    formula ="logrealearn ~ black + ageg2 + ageg3 + ageg4 + ageg5 + other",
    data = .,
    tau = 0.5,
    weights = perwt
  )
summary(Quant_reg)


*Sample 1


years <- merged_data %>% distinct(year) %>% pull(year)
formula1 = "logrealearn ~ black + ageg2 + ageg3 + ageg4 + ageg5 + other"
betas_1 = c()
# Sample 1
for (i in 1:length(years)) {
  Quant_reg <- merged_data %>% filter(year == years[i]) %>%
    filter(sample1 == 1) %>%
    rq(formula = formula1,
       data = .,
       tau = 0.5,
    weights = perwt)
  betas_1[i] = Quant_reg$coefficients['black']
}


*Sample 2

betas_2 = c()
# Sample 2
for (i in 1:length(years)) {
  Quant_reg <- merged_data %>% filter(year == years[i]) %>%
    filter(sample2 == 1) %>%
    rq(formula = formula1,
       data = .,
       tau = 0.5,
    weights = perwt)
  betas_2[i] = Quant_reg$coefficients['black']
}


*Sample 3

betas_3 = c()
# Sample 3
for (i in 1:length(years)) {
  Quant_reg <- merged_data %>% filter(year == years[i]) %>%
    filter(sample3 == 1) %>%
    rq(formula = formula1,
       data = .,
       tau = 0.5,
    weights = perwt)
  betas_3[i] = Quant_reg$coefficients['black']
  
  }

  
  data_frame1 <- data.frame(betas_1, betas_2, betas_3, years)
names(data_frame1) <- c("Working Men Only (Sample 1)", "All Men (Sample 2)", "All Men and Women (Sample 3)", "year")
combined <- data_frame1 %>% gather(key="Sample", value="beta", -year)
kable(head(combined))



*Combined Chart

ggplot(data = combined, aes(x = year, y = beta, group = Sample)) +
geom_line(aes(color = Sample)) +
geom_point(aes(color = Sample)) +
ylim(-1,0) +
ggtitle("Median white-black Real Earnings Gap (in log points)") +
ylab("Real Earnings Gap (in log points)") +
xlab("Year")


*Sample Chart 1

ggplot(data = combined %>% filter(Sample == "Working Men Only (Sample 1)")
       , aes(x = year, y = beta, group = Sample)) +
geom_line(aes(color = Sample)) +
geom_point(aes(color = Sample)) +
ylim(-1,0) +
ggtitle("Median white-Black Real Earnings Gap (in log points)") +
ylab("Real Earnings Gap (in log points)") +
xlab("Year")


*Sample Chart 2

ggplot(data = combined %>% filter(Sample =="All Men (Sample 2)")
       , aes(x = year, y = beta, group = Sample)) +
geom_line(aes(color = Sample)) +
geom_point(aes(color = Sample)) +
ylim(-1,0) +
ggtitle("Median white-Black Real Earnings Gap (in log points)") +
ylab("Real Earnings Gap (in log points)") +
xlab("Year")


*Sample Chart 3

ggplot(data = combined %>% filter(Sample =="All Men and Women (Sample 3)")
       , aes(x = year, y = beta, group = Sample)) +
geom_line(aes(color = Sample)) +
geom_point(aes(color = Sample)) +
ylim(-1,0) +
ggtitle("Median white-Black Real Earnings Gap (in log points)") +
ylab("Real Earnings Gap (in log points)") +
xlab("Year")

*/
