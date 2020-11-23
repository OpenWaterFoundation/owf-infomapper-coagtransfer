# 06-Calculate-WaterDistrictPopulation-withinUnincorporated

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to estimate the amount of a water district's population 
that is within unincorporated county land.

In WWR's analysis (report, p.10), water district populations were determined in one of three ways:  
1.  For intersections between a water district and municipality, the water district service population was estimated 
as the pro-rata portion of the municipal land area within the water district. For example, a water district 
intersecting 22% of a municipal developed area was allocated 22% of that municipality's population.  For 
intersections between a water district and county unincorporated areas, the water district service population was 
estimated on a case-by-case basis (2 and 3 below). 
2. For water districts serving more urbanized unincorporated areas, the water district service population was 
estimated based on the land area intersection multiplied by a proximal municipality's population density. 
3. For water districts serving more rural unincorporated areas, the water district service population was estimated 
based on the county's specific unincorporated population density. 

Methods 2 and 3 are addressed in this folder.  OWF used a different methodology.  OWF assumed that the unincorporated 
portion of a water district's population can be set as a constant proportion of the associated county's unincorporated 
population (as was also assumed for municipalities as a portion of the county population).

The proportion of a water district's developed land within intersecting unincorporated county land that is also developed, 
as calculated in `01-Calculate-Municipal-WaterDistrictAreas`, is multiplied by the intersecting unincorporated county 
population estimates up to 2050 to estimate the population of the water district within the associated unincorporated county.

The water district population estimates within unincorporated areas are provided in the file "district-unincorporated-population.csv" 
in folder `08-Calculate-WaterDistrict-LandGrowth`.

The total water district population estimates (both municipal and unincorporated areas) are provided in the file 
"waterdistrict-population.csv" in folder `10-Calculate-Demand`.
