# Calculation of water district populations, part 2: unincorporated proportion of water district

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

# This script addresses #2 and #3 above.  OWF IS USING A DIFFERENT METHODOLOGY.  As described also in step #5, OWF
# is assuming that the unincorporated portion of a water district's population can be set as a constant proportion of
# the associated county's unincorporated population.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "waterdistrict-population-unincorporated.R"
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
# TODO smalers 2020-11-23 changed the following line - confirm that it is OK (Kristin must have manually copied?)
#props = read.csv("waterdistrict-proportions.csv", header=TRUE)
props = read.csv("..\\05-Calculate-WaterDistrictPopulation-withinMunis\\waterdistrict-proportions.csv", header=TRUE)
head(props)

# b. Read in municipal population forecast data.  Population will be multiplied by 'Proportion_of_Muni' to 
# get water district populations
muni_pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv")
head(muni_pop)

# c. Read in future population densities as calculated in `04-Calculate-FutureDensity\\future-density.R`.  Will use 
# the density estimates as well as population estimates.
# TODO smalers 2020-11-23 changed the following line - confirm that it is OK (Kristin must have manually copied?)
# density = read.csv("future-municipal-density.csv", header=TRUE)
density = read.csv("..\\05-Calculate-WaterDistrictPopulation-withinMunis\\future-municipal-density.csv", header=TRUE)
head(density)

# d. Read in land development calculations for water districts
district_develop = read.csv("waterdistrict-land-development.csv", header=TRUE)
head(district_develop)

# e. Read in land development calculations for unincorporated lands
unincorp_develop = read.csv("unincorporated-land-development.csv", header=TRUE)
head(unincorp_develop)


# 2) Use the proportion dataset to find out how much of a given water district is within a municipal 
# boundary.
props2 = props %>%
  group_by(WaterProvider, County) %>% # Group by water district/county combo
  summarize(Municipal_Proportion_of_District = sum(Proportion_of_District)) %>%
  # Subtract 'Municipal_Proportion_of_District' from 1 to get the unincorporated proportion
  mutate(Unincorporated_Proportion_of_District = 1 - Municipal_Proportion_of_District)
props2 = as.data.frame(props2)
# Round decimal places to 2 digits
props2$Municipal_Proportion_of_District = round(props2$Municipal_Proportion_of_District, digits = 2)
props2$Unincorporated_Proportion_of_District = round(props2$Unincorporated_Proportion_of_District, digits = 2)

# Results are summarized for 21 districts out of 28.  Therefore, 7 are completely within unincorporated areas.  These 
# are Centennial WSD, Donala WSD, Forest View Acres WD, Louviers WSD, Pueblo West Metropolitan District, 
# Roxborough WSD and St. Charles Mesa WD.


# 3) Filter 'unincorp_develop' to just developed land
unincorp_develop2 = unincorp_develop %>%
  filter(LandDevelopment == "Developed")


# 4) Summarize the proportion of developed land within a water district by county
district_develop2 = district_develop %>%
  filter(LandDevelopment == "Developed") %>%
  group_by(WaterProvider, County) %>%
  summarize(Area_sqmiles = sum(Area_sqmiles))
district_develop2 = as.data.frame(district_develop2)

# 5) Link this to the amount of developed land within the unincorporated county.  This proportion will be used with 
# the county's unincorporated population estimate to estimate the water district's population.  This proportion will
# be held constant to 2050 (as was also assumed for municipalities as a portion of the county population).
district_prop = left_join(district_develop2, unincorp_develop2, by = c("County" = "County"))
# Calculate proportion
district_prop = district_prop %>%
  mutate(Proportion_of_Unincorp = Area_sqmiles.x / Area_sqmiles.y) %>%
  # Simplify dataset
  dplyr::select(WaterProvider, County, Proportion_of_Unincorp)


# 6) Link 'district_prop' to the population estimates for unincorporated county areas to 2050
# First filter 'muni_pop' to only unincorporated areas
unincorp_pop = muni_pop %>%
  filter(grepl("Unincorporated Area", MunicipalityName))
# Join with 'district_prop'
district_pop = left_join(unincorp_pop, district_prop, by = c("County" = "County"))
# Calculate water district population
district_pop = district_pop %>%
  mutate(WaterDistrict_Population = Municipal_Population * Proportion_of_Unincorp) %>%
  # Simplify dataset
  dplyr::select(WaterProvider, County, Year, WaterDistrict_Population) %>%
  arrange(WaterProvider, County, Year)
# Round population to whole numbers
district_pop$WaterDistrict_Population = round(district_pop$WaterDistrict_Population, digits = 0)
# Remove NAs because they don't have a water district associated with them
district_pop = na.omit(district_pop)


# 7) Export data
# Export 'district_pop' to folder '08-Calculate-WaterDistrict-LandGrowth' so that the land growth of water districts 
# can be estimated.
write.csv(district_pop, "..\\08-Calculate-WaterDistrict-LandGrowth\\district-unincorporated-population.csv", 
          row.names = FALSE)

# Read in district populations within municipalities to calculate total water district population
district_muni_pop = read.csv("..\\07-Adjust-MunicipalPopulation\\district-municipal-population.csv", header = TRUE)
# Filter to one density option since they are all the same and then delete the column
district_muni_pop = district_muni_pop %>%
  # Summarize by water provider/county combo
  group_by(WaterProvider, County, Year) %>%
  summarize(WaterDistrict_Population = sum(WaterDistrict_Population))
total_district_pop = left_join(district_pop, district_muni_pop, by = c("WaterProvider" = "WaterProvider", "County" = 
                                                                         "County", "Year" = "Year"))
# Set NAs to 0 because the NAs represent districts that do not have any municipal population
total_district_pop[is.na(total_district_pop)] = 0
# Add populations together
total_district_pop = total_district_pop %>%
  mutate(Population = WaterDistrict_Population.x + WaterDistrict_Population.y) %>%
  dplyr::select(WaterProvider, County, Year, Population)
# Export
write.csv(total_district_pop, "..\\10-Calculate-Demand\\waterdistrict-population.csv", row.names = FALSE)



# 8) Create graphs for quality control
ggplot(district_muni_pop, aes(x = Year, y = WaterDistrict_Population, color = County)) +
  geom_point()

# Split by county 
adams = district_muni_pop %>%
  filter(County == "Adams")
ggplot(adams, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

arapahoe = district_muni_pop %>%
  filter(County == "Arapahoe")
ggplot(arapahoe, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

boulder = district_muni_pop %>%
  filter(County == "Boulder")
ggplot(boulder, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

douglas = district_muni_pop %>%
  filter(County == "Douglas")
ggplot(douglas, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

elpaso = district_muni_pop %>%
  filter(County == "El Paso")
ggplot(elpaso, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

jefferson = district_muni_pop %>%
  filter(County == "Jefferson")
ggplot(jefferson, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

larimer = district_muni_pop %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()

weld = district_muni_pop %>%
  filter(County == "Weld")
ggplot(weld, aes(x = Year, y = WaterDistrict_Population, color = WaterProvider)) +
  geom_line()
