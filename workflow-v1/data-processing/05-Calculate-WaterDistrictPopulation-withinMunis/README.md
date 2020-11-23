# 05-Calculate-WaterDistrictPopulation-withinMunis #

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to estimate the amount of a water district's population 
that is within a municipality's boundaries.

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

Method 1 is addressed in this folder.

The proportion of a water district within an intersecting municipality, as calculated in `01-Calculate-Municipal-WaterDistrictAreas`, 
is multiplied by the intersecting municipality's population estimates up to 2050 to estimate the population of the 
water district within the associated municipality's boundaries.  The municipality's population is subsequently 
adjusted to account for this population in a later step so that there is not a double-counting of population. 

The water district population estimates within municipalities are provided in the file "district-municipal-population.csv" 
in folder `07-Adjust-MunicipalPopulation`.
