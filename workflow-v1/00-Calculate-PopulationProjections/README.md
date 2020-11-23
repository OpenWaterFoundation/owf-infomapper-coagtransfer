# 00-Calculate-PopulationProjections #

**This step needs to be replaced by the newer TSTool and equivalent
process in `/workflow/BaselineScenario/01-MunicipalPopulation`.**

Run the R script via TSTool `01-run-r-script.tstool` command file,
which copies input files from the legacy files and then runs the R script.

## Original Comments ##

This folder contains municipal and county population data and an R script that
calculates the proportion of municipal population within each county 
for the years 2018-2050 since there are no population forecasts for municipalities in Colorado.

Population data are from DOLA and were pre-processed in the folders
`01-Download-CountyPopulation` and `02-Download-MunicipalPopulation-DOLA` within the 
`data-downloads-and-preprocessing` folder.
 
Municipal populations are summarized by county and subtracted from county
totals to find the remainder, which is counted as "Unincorporated Area" for that county.

The percent proportion of the county population that is the municipality or
unincorporated area is calculated from 2017 data.  This proportion for each 
municipality was held constant up to 2050 to estimate municipal populations from 2018 to 2050.
The file "municipal-proportions.csv" provides the proportions.

The forecasted municipal population estimates are provided in the file "municipal-population-forecast.csv"
