# 02-Calculate-PopulationDensity #

Run the R script via TSTool `01-run-r-script.tstool` command file.

## Original Comments ##

This folder contains population density estimates for municipalities for the year 2018.
Municipalities within multiple counties have separate densities for each county.

The R script ("population-density.R") calculates density by using the
municipal boundaries spatial data layer, which has incorporated 
all annexations through 2018 and the forecasted municipal population
data ("municipal-population-forecast.csv"), which were calculated in folder 
`00-Calculate-PopulationProjections`.

Population densities are exported as "population-density.csv".
A scatterplot of population vs. density was used to develop seven population bins 
as described by WestWater Research.
Each population bin was then assigned density assumptions based on the population range.
See the README for folder `03-Calculate-LandAreaGrowth` for more information.









 

