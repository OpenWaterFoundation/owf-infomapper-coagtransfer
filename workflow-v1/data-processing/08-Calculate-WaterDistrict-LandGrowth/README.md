# 08-Calculate-WaterDistrict-LandGrowth

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to calculate new land area development for water districts. 
Districts are split by county as needed for those districts in multiple counties.

To estimate the land growth of each water district, population needs to be divided by some kind of density 
assumption as was done for municipalities.  The logic is as follows:

1. For water districts serving more urbanized unincorporated areas, districts will be placed into population 'bins' 
as was done for municipalities and then assigned density assumptions based on their 2018 populations.

2. For water districts serving more rural unincorporated areas, the density assumption will be held constant and will 
be calculated as the population density of the associated county's unincorporated area in 2018.

Similar to the processes performed for municipal land growth, population density was first calculated for unincorporated 
county areas for 2018.

Then the difference in population from one year to the next for both water districts and unincorporated areas was calculated.

Water districts were split into urban and rural districts.  **OWF could not determine from WWR's original analysis how 
districts were divided, so this may need to be reviewed by WWR.**

For urban districts, the process was similar to that done for municipalities, in which the district was placed into a 
population bin and then assigned density assumptions based on the population bin.

For rural districts, WWWR's analysis did not mention options for density.  For now, OWF is assuming that there are NOT 
density options for rural districts and will use the unincorporated county density for 2018 up to 2050.  Thus, when this 
data is merged with other data, density options have the same values.  **This should be reviewed by WWR.**

New land growth was calculated by dividing the annual change in population by each of the three density options.

The cumulative amount of new growth each year was calculated.

The total amount of land area of each water district per year was calculated by adding the cumulative growth to the 
water district area calculated for 2018.

Water district build-out is then considered, as was done for municipalities.  Any water district whose growth area for a 
given year is greater than the build-out area is set to the build-out area and held to 2050.  Then any new growth is reset 
to 0 (which means that population density will increase) and cumulative land growth is recalculated accordingly.

New land growth of water districts by county is summarized.

Total water district land area by county is summarized.

Land growth estimates for water districts are then combined with land growth estimates for municipalities.  This data 
can be found in the file "provider-land-area-growth.csv" in folder `11-Map-LandDevelopment`.

