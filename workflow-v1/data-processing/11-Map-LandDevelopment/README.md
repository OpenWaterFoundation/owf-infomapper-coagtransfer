# 11-Map-LandDevelopment #

Run the R scripts via TSTool `01-run-r-script.tstool` command file.

## Original Comments ##

The following describes the rationale and processes used to estimate how municipal and water district land growth will occur.

The overall objective of this step is to spatially identify where new population will be located along the Front Range.  The 
mapping analysis is a necessary step to estimate growth onto irrigated and non-irrigated lands.  The future land development 
specific to each municipality was mapped using best judgment and the following assumptions in WWR's original analysis:
* Municipalities will first use undeveloped lands and irrigated lands within their existing built out areas to support new growth, 
before expanding the build out footprint.
* Unincorporated areas that currently support a significant population were not assumed to support any new growth.  
* Where possible, municipal growth onto enclaves (unincorporated areas which are completely surrounded by municipal boundaries) 
were prioritized before expanding the municipal build out footprint.
* Municipal growth outside of the existing developed footprint occurs in a radial fashion, with new land development assigned 
directly next to current built areas where possible.

The specific objectives are to take the amount of annual new growth in square miles for each water provider and convert the amount 
to a count of cells(pixels) in the raster.  The cells need to belong to the Land Development category of "Potentially Developable". 
Those cells will then be reclassified as "Developed" for that year and forward to 2050.  This reclassified raster will then be used 
to estimate land growth for the following year.  The process will be repeated to the year 2050.
  
The process for estimating the locations of land growth used the following steps:

1. New land growth (in square miles) from the data files "municipal-land-area-growth.csv" and "district-land-area-growth.csv" is 
converted to the number of raster cells needed to reclassify from "Potentially Developable" to "Developed" for each 
water provider/county combination for each year and density of growth option.  This step is performed in the script 
"convert-area-to-raster-cells.R".  Data are saved in the files "municipal-cells-to-reclassify.csv" and "district-cells-to-reclassify.csv"

2. The LandDevelopment raster is split into two new rasters, one of "Developed" land and one of "Potentially Developable" land. 
New land growth can only occur on the "Potentially Developable" raster. 

3. Masks are created for each water provider to limit analysis to within municipal/district boundaries.  This ensures that growth is 
associated with the correct water provider.

4. Using the mask for each water provider, the distance of cells from the "Developed" raster is calculated. 

5. The water provider distance rasters are merged together to create a single distance raster.  The distance raster is saved as a 
spatial GeoTIFF file (one for municipalities and one for water districts).  This saves processing time for subsequent steps.

6. A raster stack of the water provider, distance, potentially developable land, irrigated land, developed land, and county layers is 
created.  The stack serves to align all of the rasters together with the same extent and resolution.

7. Iterating over each water provider/county/year/density of growth combination in the raster stack, the number of cells to reclassify 
from "Potentially Developable" to "Developed" (found in the "municipal-cells-to-reclassify.csv" and "district-cells-to-reclassify.csv" 
files) is extracted from the raster. To determine which cells to extract, the cells are filtered to only those that are potentially 
developable and then sorted by the minimum distance (but greater than zero) from already developed lands, and are irrigated (irrigated 
prioritized first, then non-irrigated). The top 'n' number of cells are extracted and then assigned to that year.

8. The extracted cells are then reclassified (changed from 0 to 1 for developed land and from 1 to 0 for potentially developable land) so 
that they cannot be selected in subsequent years.  The process is repeated to the year 2050.

These steps require a lot of memory to process, so the procedure is completed in multiple scripts.
Steps 1-5 are performed in the script "land-development-mapping-part1.R". Steps 6-8 are performed in the script 
"land-development-mapping-part2.R" for municipalities and "land-development-mapping-part3.R" for water districts.

Outputs are spatial GeoTIFF files:
* Low_Density_Municipal_Growth.tif
* Medium_Density_Municipal_Growth.tif
* High_Density_Municipal_Growth.tif
* District_Growth.tif

An example output of medium density municipal growth in the Fort Collins-Greeley area is shown below.
![Map-LandDevelopment 1](../../../doc-images/municipal-growth-noco.png)
