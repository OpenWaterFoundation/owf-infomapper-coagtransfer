# 10-Calculate-Demand

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to calculate water demand of municipalities and water districts. 
Municipalities are split by county and districts are split by municipality and county as needed.

Municipal and water district (provider) population estimates to 2050 are used, as well as water use estimates in the form of gallons per
capita per day (GPCD); the script calculates water demand as population multiplied by GPCD for each municipality and water district with 
a GPCD estimate for the years 2018-2050.  Amounts are converted to acre-feet per year.

Municipal population estimates have been adjusted so that the proportion of the municipality that is within a water district is included in 
that district's population.  Thus, there are some municipalities whose populations are listed as 0 because the municipality falls entirely 
within a water district.  As an example, the town of Foxfield is entirely within the boundaries of Arapahoe County Water and Wastewater 
Authority (ACWWA), so the population of Foxfield is listed as 0 and its population is incorporated into ACWWA.

The file 'gpcd.csv' lists water use estimates for municipalities and water districts.  GPCD estimates were provided by WestWater Research 
and were compiled from reports specific to each municipality/water district.  WestWater Research obtained GPCD estimates for about 40% of 
analyzed water providers, representing about 80% of the population.  For those municipalities and water districts that did not have a reported 
GPCD, WestWater Research made an estimate based on other water providers with a similar service size and proximal location.  Note that there 
are approximately 40 municipalities and water districts that do not have GPCD estimates, so demand was not calculated for these entities.

The GPCD estimates compiled as described above are considered 'normal' estimates.  Two other GPCD estimates, categorized as 'efficient' and
'inefficient' were considered.  An efficient GPCD was calculated as the normal GPCD multiplied by 0.85.  An inefficient GPCD was calculated 
as the normal GPCD multiplied by 1.15.  Therefore, there are three sets of demand estimates provided for municipalities and water districts 
depending on the level of water use efficiency.

Water demand estimates can be found in the file... TO BE FILLED IN.






 

