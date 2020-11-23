# 01-Calculate-Municipal-WaterDistrictAreas #

**The Python script needs to be replaced with a GeoProcessor command file.**

Run the R script via TSTool `01b-run-r-script.tstool` command file,
which copies input files from the legacy files and then runs the R script.

## Original Comments ##

This folder does initial processing of the raster spatial files provided by WestWater Research.

5 raster files were provided that are rasterized layers representing counties, municipal boundaries, water district boundaries, irrigated lands 
and developed/developable lands.

Each raster was reprojected to NAD83 UTM Zone 13N so that units are in meters and then a virtual raster was built where each raster layer is a band 
within the same raster.  These steps were completed in the file 'raster-processing-initial.py'.

The virtual raster is then read into R for further processing.  The script 'raster-processing-initial.R' takes the virtual raster and extracts
the data from each band as a single dataframe so that calculations on the data can be performed.  For example, the area of each municipality that is 
developed land, developable land, and not developable land is calculated.

The script then summarizes:
* the area of each municipality and water district, split by county as needed for those municipalities/water districts that are in multiple counties.
* the area of each county.
* the area of overlap between municipalities and water districts.
* the proportion of overlap (calculated from the above step) to total area of each municipality and water district, split by county as necessary.
* the area of each municipality/land development combination, with municipalities split by county as necessary.  This step is needed to understand at which point (area) to certain municipalities reach municipal build-out.
* the amount of developed land in unincorporated county areas.  Note that this includes areas WITHIN water district boundaries.  This assists with estimating water district populations in unincorporated areas.
* the area of each water district/land development combination, split by county as necessary.  This focuses on the portion of the water district NOT within a municipality's boundaries.

Data are then exported as follows:  
* Municipal areas are exported as "municipal-area.csv" to folder `02-Calculate-PopulationDensity`
* County areas are exported as "county-area.csv" to folder `02-Calculate-PopulationDensity`
* Water district areas are exported as "waterdistrict-area.csv" to folder `05-Calculate-WaterDistrictPopulation-withinMunis`
* Water district proportions are exported as "waterdistrict-proportions.csv" to folder `05-Calculate-WaterDistrictPopulation-withinMunis`
* Municipal/land development combination areas are exported as "municipal-land-development.csv" to folder `02-Calculate-PopulationDensity`
* Unincorporated areas/land development combination areas are exported as "unincorporated-land-development.csv" to folder `06-Calculate-WaterDistrictPopulation-withinUnincorporated`
* Water district/land development combination areas are exported as "waterdistrict-land-development.csv" to folder `06-Calculate-WaterDistrictPopulation-withinUnincorporated`
