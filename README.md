# Measuring-black-and-white-inequalities
This project analysis dataset on black-white earnings gaps over 1950-2019  at the median (and 90th percentile) controlling for age groups.

Runtime

Approximately 5 minutes 

Data and Code Availability Statement

Data on measuring inequalities between black and white, these datasets show the log point difference between Log earnings for Black individuals at the median of the Black earnings distribution vs. white individuals at the median of the white earnings distribution.
The dataset is publicly available at www.ipums.org.

Steps to download the data from Ipums website:

1. Visit www.ipums.org.
2. Select IPUMS USA for ACS/Census data.
3. Select Get Data.
4. Scroll through the different categories of variables per Person to select the following variables (or use the Search function): 
a.race 
b.hispan
c.age
d.sex
e.ind1950
f.incwage
g.incbusfm
h.incfarm
i.incbus
j.incbus00
5. Select View Cart.
6. Select Add More Samples.
7. Check “default sample from each year.”
a.Deselect the years before 1950.
8. Submit Sample Selections.
9. Click Create Data Extract.
10. Select Customize Sample Sizes and enter “0.05” as the density for all samples.
11. Describe your extract with “Bayer and Charles (2018) Replication – PP 249” or a similar title.
12. Click “Submit Extract.”
13. You will be redirected to a page to Sign In or Create an Account.
a. Click Create an account in the bottom right and fill out the necessary information.
b. Submit your account creation form and then log in.
14. You should be redirected back to the “Extract Request” page where you should click “Submit Extract” again.
a. If you are not for some reason, you can repeat steps 1-11 now that you are logged in, but IPUMS should have saved your progress.
15. You will then be redirected to a page where you can download and revise extracts.
a. This extract will be “processing.”
b. You will receive an email and link when your extract is ready for download.

Computational Requirements

All code and analysis were run on Stata.

Instructions for Data Preparation and Analysis

To replicate this analysis, the user should update the MASTER.do file to include their file paths and run the file.

Figures produced by the code.

Fig1, Sample Chart 1: Median White-Black Real Earnings Gap (in log points) for “Working Men Only”

Fig2, Sample Chart 2: Median White-Black Real Earnings Gap (in log points) for “All Men”

Fig3, Sample Chart 3: Median White-Black Real Earnings Gap (in log points) for “All Men and Women”

Fig4, Combined Chart: Real Earnings Gap (in log points)
