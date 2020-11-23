# Calculation of water district populations, part 1:  municipal proportion of water district

# BACKGROUND:  from WestWater Research's report (p.10), water district populations were determined in one of three ways.
# First, water district boundaries were overlayed onto municipal boundaries to quantify portions of the municipal and 
# unincorporated populations served by a local water district.  Each water district's service area boundary was 
# intersected with municipal and unincorporated areas using GIS processes.  
# 1.  For intersections between a water district and municipality, the water district service population was estimated 
# as the pro-rata portion of the municipal land area within the water district. For example, a water district 
# intersecting 22% of a municipal developed area was allocated 22% of that municipality's population.  For 
# intersections between a water district and county unincorporated areas, the water district service population was 
# estimated on a case-by-case basis (2 and 3 below). 
# 2. For water districts serving more urbanized unincorporated areas, the water district service population was 
# estimated based on the land area intersection multiplied by a proximal municipality's population density. 
# 3. For water districts serving more rural unincorporated areas, the water district service population was estimated 
# based on the county's specific unincorporated population density. 

# Finally, as population was allocated to water districts, population was thereby lowered accordingly for 
# municipalities and unincorporated areas. 

# This script addresses #1 above.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\05-Calculate-WaterDistrictPopulation-withinMunis\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "waterdistrict-population-municipal.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr)  # For data manipulation and clean-up
library(tidyr)  # For data manipulation and clean-up
library(ggplot2) # For data visualization

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1) Read in data
# a. Read in water district proportions as calculated in 01-Calculate-Municipal-WaterDistrictAreas.  From the script 
# 'raster-processing-initial.R', the proportion of a water district within an intersecting municipality was 
# calculated and exported in the file 'waterdistrict-proportions.csv'.
props = read.csv("waterdistrict-proportions.csv", header=TRUE)
head(props)

# b. Read in municipal population forecast data.  Population will be multiplied by 'Proportion_of_Muni' to 
# get water district populations
muni_pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv")
head(muni_pop)

# c. Read in future population densities as calculated in `04-Calculate-FutureMunicipalDensity\\future-density.R`.  
# Will use the density estimates as well as population estimates.
density = read.csv("future-municipal-density.csv", header=TRUE)
head(density)


# 2) Merge density and proportion datasets
district_pop_muni = left_join(props, density, by = c("Municipality" = "MunicipalityName", "County" = "County"))


# 3) Delete rows with NAs because they do not have any population associated with them
district_pop_muni = na.omit(district_pop_muni)


# 4) Calculate water district population by multiplying 'Municipal_Population' by "Proportion_of_Muni'
district_pop_muni = district_pop_muni %>%
  mutate(WaterDistrict_Population = Municipal_Population * Proportion_of_Muni) %>%
  # Get rid of density option since this doesn't differ for population
  filter(Density_Option == "Low") %>%
  dplyr::select(WaterProvider, Municipality, County, Year, WaterDistrict_Population)
# Round district populations to whole numbers
district_pop_muni$WaterDistrict_Population = round(district_pop_muni$WaterDistrict_Population, digits = 0)


# 5) Group data by water district, county and year and then summarize to get the water district population 
# for a given year (currently population is broken out in the different munis)
district_pop = district_pop_muni %>%
  group_by(WaterProvider, County, Year) %>%
  summarize(WaterDistrict_Population = sum(WaterDistrict_Population))
  

# Note that this is only the water district population within municipalities; the proportion within unincorporated 
# areas still needs to be calculated.  That is done next.


# 6) Export data
# Export 'district_pop_muni' to folder '07-Adjust-MunicipalPopulation' so that municipal populations can be adjusted
write.csv(district_pop_muni, "..\\07-Adjust-MunicipalPopulation\\district-municipal-population.csv", row.names = FALSE)


# 7) TODO:  Create graphs for quality control
#ggplot(district_pop_muni, aes(x = Year, y = WaterDistrict_Population, color = County)) +
#  geom_point() +
#  facet_grid(. ~ Density_Option)


