# 09-Check-Population

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script that is a basic data check on the population calculations from previous steps.  Municipal 
and water district populations are summed together and compared to county population estimates.

Municipal population estimates calculated in `00-Calculate-PopulationProjections` and adjusted in `07-Adjust-MunicipalPopulation` 
are summed with water district population estimates calculated in `05-Calculate-WaterDistrictPopulation-withinMunis` and 
`06-Calculate-WaterDistrictPopulation-withinUnincorporated`.

The summed population numbers are compared to the county population estimates from DOLA as provided in `00-Calculate-PopulationProjections`. 
With the exception of Broomfield County, there should be some remaining population, which is considered either unincorporated county 
population or population from water districts not considered in this study.  Many small districts around Denver were 
not part of the analysis.

No data files are exported in this step.  However, if it is desired to output results, the command file can be edited to do so.
