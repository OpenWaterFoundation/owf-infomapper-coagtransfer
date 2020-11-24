# 12-Calculate-Supply

Run the R scripts via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to calculate water supply of municipalities and water districts. 
Municipalities are split by county and districts are split by municipality and county as needed.

Water supply estimates were provided by WestWater Research and were compiled from reports specific to each municipality/water 
district.  There are options here for average yield and firm yield (which is average yield * 0.66).

Added to supply estimates are supplies from future water projects, which were also compiled by WestWater Research.  These were 
compiled relative to the original 2020, 2030, 2040 and 2050 analysis years.  In some cases, the specific year is included.  OWF 
intends to fill in supply between years.

Further added is the water that comes from irrigated lands that are purchased by municipalities/water districts as they expand 
and are converted from agricultural to municipal uses.  This is calculated as the converted irrigated acreage (estimated in 
`11-Map-LandDevelopment`) multiplied by the average net irrigation requirement (crop NIR) of the crops grown on the converted 
land.

**More detailed information will be provided for this step once the process is completed.**
