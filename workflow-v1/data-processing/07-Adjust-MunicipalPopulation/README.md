# 07-Adjust-MunicipalPopulation

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to adjust municipal population estimates 
by subtracting overlapping water district population estimates from municipal population forecasts.

Water district populations were calculated in `05-Calculate-WaterDistrictPopulation-withinMunis`. 
Since the water districts can overlap municipal boundaries, population was calculated as a proportion of 
that overlap.  Thus, population needs to be lowered accordingly for municipalities. 

The new municipal population estimates are provided in the file "municipal-population.csv" in folder 
`10-Calculate-Demand`.
