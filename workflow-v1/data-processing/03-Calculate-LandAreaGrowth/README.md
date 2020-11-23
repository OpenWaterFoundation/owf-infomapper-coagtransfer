# 03-Calculate-LandAreaGrowth #

Run the R script via TSTool `run-r-script.tstool` command file.

## Original Comments ##

This folder contains a script and associated data files needed to calculate new land area development for municipalities. 
Municipalities are split by county as needed for those municipalities in multiple counties.

From WestWater Research's report (p.15), land area development estimates were made by taking the municipal population 
projections and applying an estimated population density (persons per square mile). Population density was estimated 
to increase as municipalities grow and urbanize. A scatterplot of population vs. density was used to develop seven 
different density assumptions based on population.  The density assumptions are replicated in the script 
'land-area-growth.R'.  As an example, if a municipality with a population of 35,000 grows by 3,000 people in a year, 
the associated new land development area is estimated to be 3,000/2,700 = 1.11 square miles.  The 2700 number comes 
from a medium density assumption for a municipality with a population between 20,000 and 50,000.  OWF is using the 
categories of "Low", "Medium", and "High" to describe the density assumptions. 

To begin, the difference in population from one year to the next is calculated.

New land growth is calculated by dividing the annual population change by each of the three density options.

The cumulative amount of new growth each year is calculated.

The total amount of land area of each municipality per year is calculated by adding the cumulative growth to the 
municipal area calculated for 2018.

Municipal build-out is then considered.  From WestWater Research's report, additional population growth could not be 
accommodated for some municipalities by increasing the developed land area within the municipal boundary. In these cases 
of municipal build-out, additional population growth was assumed to occur through increased population density within the 
build-out boundary of the municipality and the population density estimates were not applied.

The maximum amount of land area growth possible was calculated.  Using the LandDevelopment raster provided by WWR, this 
equates to summarizing the number of "Developed" and "Potentially Developable" cells within a municipal boundary.  This 
also equates to municipal build-out.

Any municipality whose growth area for a given year is greater than the build-out area is set to the build-out 
area and held to 2050.  Then any new growth is reset to 0 (which means that population density will increase) and 
cumulative land growth is recalculated accordingly.

New land growth of municipalities by county is summarized.

Total municipal land area by county is summarized.

The land growth estimates are provided in the file "municipal-land-area-growth.csv" in folder `04-Calculate-FutureMunicipalDensity`.
