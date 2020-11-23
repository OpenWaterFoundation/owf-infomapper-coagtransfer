# Calculation of new land area development for water districts

# Land area growth will use population estimates for water districts split by county as necessary.  Note that we are
# only considering growth of the district outside of any municipality it may intersect; that growth should have 
# been incorporated as municipal growth.

# From folder '06-Calculate-WaterDistrictPopulation-withinUnincorporated', water district population estimates were 
# calculated to 2050 for the unincorporated portion of the district as a constant proportion of the overall county's
# unincorporated population (which is provided by the State Demographer's Office, or DOLA).

# To estimate the land growth of each water district, the unincorporated population needs to be divided by some kind 
# of population density estimate.  To calculate population density, the estimated unincorporated district 2018 
# population is divided by the amount of developed land within the district's 2018 boundary (but outside of any 
# overlapping municipality's boundary).  This population density estimate is held constant to 2050.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd("E:\\Data\\data-processing\\08-Calculate-WaterDistrict-LandGrowth\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "district-land-area-growth.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr)  # For data manipulation and clean-up
library(tidyr)  # For data manipulation and clean-up
library(ggplot2) # For data visualizations

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1) Read in data
# a. Read in water district population forecast data from 06-Calculate-WaterDistrictPopulation-withinUnincorporated
# This is the unincorporated population only
district_pop = read.csv("district-unincorporated-population.csv", header=TRUE)
head(district_pop)

# b. Read in unincorporated population forecast data
#unincorp_pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv")
#unincorp_pop = unincorp_pop %>%
#  filter(grepl("Unincorporated Area", MunicipalityName))
#head(unincorp_pop)

# c. Read in amount of unincorporated land that is developed
#unincorp_land = read.csv("..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\unincorporated-land-development.csv", header=TRUE)
#unincorp_land = unincorp_land %>%
#  filter(LandDevelopment == 'Developed')
#head(unincorp_land)

# d. Read in amount of water district land and filter to only land that is developed
district_land = read.csv("..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\waterdistrict-land-development.csv", header=TRUE)
district_land = district_land %>%
  filter(LandDevelopment == 'Developed') %>%
  group_by(WaterProvider, County) %>%
  summarize(Area_sqmiles = sum(Area_sqmiles))
head(district_land)


# 2) Calculate the population density for 2018
district_pop2018 = district_pop %>%
  filter(Year == 2018)
density = left_join(district_pop2018, district_land)
density = density %>%
  mutate(Density = WaterDistrict_Population / Area_sqmiles) %>%
  dplyr::select(WaterProvider, County, WaterDistrict_Population, Area_sqmiles, Density) %>%
  rename(Population = WaterDistrict_Population)
 

# 3) Calculate the difference in population from one year to the next
district_pop = district_pop %>%
  group_by(WaterProvider, County) %>%
  mutate(Annual_Pop_Diff = WaterDistrict_Population - lag(WaterDistrict_Population)) %>%
  arrange(WaterProvider, County)
# Change NAs to 0 to indicate no change
district_pop$Annual_Pop_Diff[is.na(district_pop$Annual_Pop_Diff)] = 0


# 4) Calculate new land growth by dividing 'Annual_Pop_Diff' by 'Density'.  Units are square 
#    miles
# First merge 'density' with 'district_pop'
land_growth = left_join(district_pop, density, by = c("WaterProvider" = "WaterProvider", "County" = "County"))
land_growth = land_growth %>%
  mutate(Growth_Area_sqmiles = Annual_Pop_Diff / Density) %>%
  dplyr::select(-Population) %>%
  rename(Population = WaterDistrict_Population)
# Set NAs to 0 because they relate to Left Hand Water District in Broomfield County, which doesn't have any population
land_growth$Growth_Area_sqmiles[is.na(land_growth$Growth_Area_sqmiles)] = 0


# 5) Calculate the cumulative amount of new growth each year by adding each year's growth to the water district areas 
#    from 2018.
total_growth = land_growth %>%
  group_by(WaterProvider, County) %>%
  mutate(Cumulative_Growth_sqmiles = cumsum(Growth_Area_sqmiles)) %>%
  rename(New_Growth_sqmiles = Growth_Area_sqmiles) %>%
  # Take 'Area_sqmiles' column for each district and add it to the 'Cumulative_Growth_sqmiles' column to get the 
  # total amount of land area of each water district for each year.
  mutate(Total_Land_Area_sqmiles = Cumulative_Growth_sqmiles + Area_sqmiles) %>%
  dplyr::select(-Population, -Annual_Pop_Diff, -Area_sqmiles)
total_growth = as.data.frame(total_growth)


# 6) Consider district build-out as was done for municipalities.

# Read back in 'waterdistrict-land-development.csv'.  Here, each water district was summarized by how much land is 
# developed, potentially developable, or not developable.
district_develop = read.csv('..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\waterdistrict-land-development.csv', header = TRUE)
head(district_develop)
# Calculate maximum amount of land area possible, which is Developed + Potentially Developable.  This equates 
# to district build-out
district_develop = district_develop %>%
  filter(LandDevelopment != "Not Developable") %>%
  group_by(WaterProvider, County) %>%
  summarize(BuildOutArea = sum(Area_sqmiles))
district_develop = as.data.frame(district_develop)
# So conclusion should be that any district whose growth area for a given year is greater than the BuildOutArea 
# from 'district_develop' should change the area (Total_Land_Area_sqmiles) to the BuildOutArea value.  Then 
# 'New_Growth_sqmiles' should be changed to 0 and 'Cumulative_Growth_sqmiles' recalculated accordingly.

# Join 'district_develop' with 'total_growth'
total_growth = left_join(total_growth, district_develop, by = c("WaterProvider" = "WaterProvider", 
                                                                            "County" = "County"))

# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set Total_Land_Area_sqmiles to equal BuildOutArea.
for (i in 1:length(total_growth$Total_Land_Area_sqmiles)) {
  if (total_growth$Total_Land_Area_sqmiles[i] > total_growth$BuildOutArea[i]) {
    total_growth$Total_Land_Area_sqmiles[i] = total_growth$BuildOutArea[i]
  } else total_growth$Total_Land_Area_sqmiles[i] = total_growth$Total_Land_Area_sqmiles[i]
}
# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set New_Growth_sqmiles to 0 and recalculate cumulative
for (i in 1:length(total_growth$Total_Land_Area_sqmiles)) {
  if (total_growth$Total_Land_Area_sqmiles[i] == total_growth$BuildOutArea[i]) {
    total_growth$New_Growth_sqmiles[i] = 0
  } else total_growth$New_Growth_sqmiles[i] = total_growth$New_Growth_sqmiles[i]
}
# Recalculate Cumulative_Growth
total_growth = total_growth %>%
  group_by(WaterProvider, County) %>%
  mutate(New_Cumulative_Growth = cumsum(New_Growth_sqmiles)) %>%
  dplyr::select(-Cumulative_Growth_sqmiles) %>%
  rename(Cumulative_Growth_sqmiles = New_Cumulative_Growth) %>%
  # Reorganize
  dplyr::select(WaterProvider, County, Year, New_Growth_sqmiles, Cumulative_Growth_sqmiles, 
                Total_Land_Area_sqmiles, BuildOutArea)


# 7) Summarize new land growth of water districts by county considering district build-out.
land_growth_summary = total_growth %>%
  group_by(County, Year) %>%
  summarize(Land_Growth_sqmiles = sum(Cumulative_Growth_sqmiles)) %>%
  mutate(Land_Growth_acres = Land_Growth_sqmiles * 640)
land_growth_summary = as.data.frame(land_growth_summary)


# 8) Summarize total water district land area by county considering district build-out.
total_land_summary = total_growth %>%
  group_by(County, Year) %>%
  summarize(Total_WaterDistrict_Land_sqmiles = sum(Total_Land_Area_sqmiles)) %>%
  mutate(Total_WaterDistrict_Land_acres = Total_WaterDistrict_Land_sqmiles * 640)
total_land_summary = as.data.frame(total_land_summary)


# 9) Summarize new land growth for both municipalities and water districts by county and compare to Table 4 
# in report
# Read in municipal land growth; interested in 'Cumulative_Growth_sqmiles' for each density option
muni_land = read.csv("..\\04-Calculate-FutureMunicipalDensity\\municipal-land-area-growth.csv", header = TRUE)
head(muni_land)

# Change 'MunicipalityName' in muni_land to 'WaterProvider
muni_land = muni_land %>%
  rename(WaterProvider = MunicipalityName)
# Join datasets
total_growth_allproviders = full_join(muni_land, total_growth)
total_growth_allproviders = total_growth_allproviders %>%
  arrange(WaterProvider, County, Density_Option)
# Summarize by county
county_total_growth = total_growth_allproviders %>%
  group_by(County, Density_Option, Year) %>%
  summarize(Cumulative_Growth_sqmiles = sum(Cumulative_Growth_sqmiles)) %>%
  # Convert to acres
  mutate(Cumulative_Growth_acres = Cumulative_Growth_sqmiles * 640) %>%
  # Filter to medium density
  filter(Density_Option == "Medium") %>%
  # Filter years to 2020, 2030, 2040, 2050
  filter(Year %in% c(2020, 2030, 2040, 2050)) %>%
  dplyr::select(-Cumulative_Growth_sqmiles) %>%
# Spread Year column into multiple columns 
  spread(Year, Cumulative_Growth_acres)
county_total_growth = as.data.frame(county_total_growth)
# Round growth to whole numbers
county_total_growth$'2020' = round(county_total_growth$'2020', digits = 0)
county_total_growth$'2030' = round(county_total_growth$'2030', digits = 0)
county_total_growth$'2040' = round(county_total_growth$'2040', digits = 0)
county_total_growth$'2050' = round(county_total_growth$'2050', digits = 0)


# 10) Export data
# Export 'total_growth' to folder '11-Map-LandDevelopment' to convert new growth in square miles to raster cells
write.csv(total_growth, "..\\11-Map-LandDevelopment\\district-land-area-growth.csv", row.names = FALSE)


# 11) Create graphs of growth and total land by county
ggplot(land_growth_summary, aes(x = Year, y = Land_Growth_sqmiles, color = County)) +
  geom_line()

ggplot(total_land_summary, aes(x = Year, y = Total_WaterDistrict_Land_sqmiles, color = County)) +
  geom_line()

# Split 'total_growth' into separate datasets by county and then graph for 
# quality-control purposes
adams = total_growth %>%
  filter(County == "Adams")
ggplot(adams, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

arapahoe = total_growth %>%
  filter(County == "Arapahoe")
ggplot(arapahoe, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

boulder = total_growth %>%
  filter(County == "Boulder")
ggplot(boulder, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

douglas = total_growth %>%
  filter(County == "Douglas")
ggplot(douglas, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

# Nothing for Elbert

elpaso = total_growth %>%
  filter(County == "El Paso")
ggplot(elpaso, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

jefferson = total_growth %>%
  filter(County == "Jefferson")
ggplot(jefferson, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

larimer = total_growth %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

pueblo = total_growth %>%
  filter(County == "Pueblo")
ggplot(pueblo, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

weld = total_growth %>%
  filter(County == "Weld")
ggplot(weld, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()
