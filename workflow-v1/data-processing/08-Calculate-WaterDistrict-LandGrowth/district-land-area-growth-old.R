# Calculation of new land area development for water districts

# Land area growth will use population estimates for water districts split by county as necessary.  Note that we are
# only considering growth of the district outside of any municipality it may intersect; that growth should have 
# been incorporated as municipal growth.

# From folder '06-Calculate-WaterDistrictPopulation-withinUnincorporated', water district population estimates were 
# calculated to 2050 for the unincorporated portion of the district as a constant proportion of the overall county's
# unincorporated population (which is provided by the State Demographer's Office, or DOLA).

# To estimate the land growth of each water district, population needs to be divided by some kind of population 
# density estimate.  To calculate population density, the estimated 2018 population is divided by the amount of 
# developed land within the district's 2018 boundary.  This population density estimate is held constant to 2050.

# Set working directory
setwd("E:\\Data\\data-processing\\08-Calculate-WaterDistrict-LandGrowth\\")

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
district_pop = read.csv("district-unincorporated-population.csv", header=TRUE)
head(district_pop)

# b. Read in unincorporated population forecast data
unincorp_pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv")
unincorp_pop = unincorp_pop %>%
  filter(grepl("Unincorporated Area", MunicipalityName))
head(unincorp_pop)

# c. Read in amount of unincorporated land that is developed
unincorp_land = read.csv("..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\unincorporated-land-development.csv", header=TRUE)
unincorp_land = unincorp_land %>%
  filter(LandDevelopment == 'Developed')
head(unincorp_land)

# d. Read in amount of water district land that is developed
district_land = read.csv("..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\waterdistrict-land-development.csv", header=TRUE)
district_land = district_land %>%
  filter(LandDevelopment == 'Developed') %>%
  group_by(WaterProvider, County) %>%
  summarize(Area_sqmiles = sum(Area_sqmiles))
head(district_land)


# 2) Calculate the population density of unincorporated county area for 2018
unincorp_pop2018 = unincorp_pop %>%
  filter(Year == 2018)
county_density = left_join(unincorp_pop2018, unincorp_land)
county_density = county_density %>%
  mutate(Density = Municipal_Population / Area_sqmiles) %>%
  dplyr::select(Municipality, County, Municipal_Population, Area_sqmiles, Density) %>%
  rename(Population = Municipal_Population)
  

# 3) Calculate the difference in population from one year to the next for both water districts and unincorporated areas
# Water districts
district_pop = district_pop %>%
  group_by(WaterProvider, County) %>%
  mutate(Annual_Pop_Diff = WaterDistrict_Population - lag(WaterDistrict_Population)) %>%
  arrange(WaterProvider, County)
# Change NAs to 0 to indicate no change
district_pop$Annual_Pop_Diff[is.na(district_pop$Annual_Pop_Diff)] = 0

# Unincorporated areas
unincorp_pop2 = unincorp_pop %>%
  group_by(MunicipalityName) %>%
  mutate(Annual_Pop_Diff = Municipal_Population - lag(Municipal_Population)) %>%
  arrange(MunicipalityName)
# Change NAs to 0 to indicate no change
unincorp_pop2$Annual_Pop_Diff[is.na(unincorp_pop2$Annual_Pop_Diff)] = 0


# 4) Split 'district_pop' into urban and rural districts
 # ** THIS MAY NEED TO BE REVISED BASED ON INPUT FROM WESTWATER RESEARCH **.
rural = district_pop %>%
  filter(WaterProvider %in% c("Central Weld County Water District", "East Larimer County Water District", 
                              "Left Hand Water District", "Little Thompson Water District", "Longs Peak Water District", 
                              "North Weld County Water District", "Perry Park Water and Sanitation District", 
                              "St. Charles Mesa Water District"))
urban = district_pop %>%
  filter(!WaterProvider %in% c("Central Weld County Water District", "East Larimer County Water District", 
                               "Left Hand Water District", "Little Thompson Water District", "Longs Peak Water District", 
                               "North Weld County Water District", "Perry Park Water and Sanitation District",
                               "St. Charles Mesa Water District"))


# URBAN DISTRICTS
# 5) Create population bins for the urban districts
# WestWater Research created population bins in which to assign density categories.  Replicate the bins.
for (i in 1:length(urban$WaterDistrict_Population)) {
  if (urban$WaterDistrict_Population[i] > 500000) {
    urban$Pop_Bin[i] = '7'
  } else if (urban$WaterDistrict_Population[i] <= 500000 & urban$WaterDistrict_Population[i] > 100000) {
    urban$Pop_Bin[i] = '6'
  } else if (urban$WaterDistrict_Population[i] <= 100000 & urban$WaterDistrict_Population[i] > 50000) {
    urban$Pop_Bin[i] = '5'
  } else if (urban$WaterDistrict_Population[i] <= 50000 & urban$WaterDistrict_Population[i] > 20000) {
    urban$Pop_Bin[i] = '4'
  } else if (urban$WaterDistrict_Population[i] <= 20000 & urban$WaterDistrict_Population[i] > 10000) {
    urban$Pop_Bin[i] = '3'
  } else if (urban$WaterDistrict_Population[i] <= 10000 & urban$WaterDistrict_Population[i] > 5000) {
    urban$Pop_Bin[i] = '2'  
  } else urban$Pop_Bin[i] = '1'
}


# 6) Assign density-of-growth assumptions
# WestWater Research, after creating the population bins, assigned estimated population densities for 
# each bin.  These can be found in the "Assumptions & Description" worksheet of "Front Range Population & Land 
# Area Projections (DRCOG).xlsx".  There are 3 options for density of growth; will use low, medium and high
# designations and assign to each water district based on its population bin category.
# The density options will be used to calculate new land development area for each year.

# Create low density of growth
for (i in 1:length(urban$Pop_Bin)) {
  if (urban$Pop_Bin[i] == '1') {
    urban$Low_Density_Growth[i] = 500
  } else if (urban$Pop_Bin[i] == '2') {
    urban$Low_Density_Growth[i] = 750
  } else if (urban$Pop_Bin[i] == '3') {
    urban$Low_Density_Growth[i] = 1100
  } else if (urban$Pop_Bin[i] == '4') {
    urban$Low_Density_Growth[i] = 1500
  } else if (urban$Pop_Bin[i] == '5') {
    urban$Low_Density_Growth[i] = 2000
  } else if (urban$Pop_Bin[i] == '6') {
    urban$Low_Density_Growth[i] = 3000  
  } else urban$Low_Density_Growth[i] = 4000
}

# Create medium density of growth
for (i in 1:length(urban$Pop_Bin)) {
  if (urban$Pop_Bin[i] == '1') {
    urban$Medium_Density_Growth[i] = 1000
  } else if (urban$Pop_Bin[i] == '2') {
    urban$Medium_Density_Growth[i] = 1400
  } else if (urban$Pop_Bin[i] == '3') {
    urban$Medium_Density_Growth[i] = 2000
  } else if (urban$Pop_Bin[i] == '4') {
    urban$Medium_Density_Growth[i] = 2700
  } else if (urban$Pop_Bin[i] == '5') {
    urban$Medium_Density_Growth[i] = 3500
  } else if (urban$Pop_Bin[i] == '6') {
    urban$Medium_Density_Growth[i] = 4400  
  } else urban$Medium_Density_Growth[i] = 5400
}

# Create high density of growth
for (i in 1:length(urban$Pop_Bin)) {
  if (urban$Pop_Bin[i] == '1') {
    urban$High_Density_Growth[i] = 1500
  } else if (urban$Pop_Bin[i] == '2') {
    urban$High_Density_Growth[i] = 2200
  } else if (urban$Pop_Bin[i] == '3') {
    urban$High_Density_Growth[i] = 3000
  } else if (urban$Pop_Bin[i] == '4') {
    urban$High_Density_Growth[i] = 3900
  } else if (urban$Pop_Bin[i] == '5') {
    urban$High_Density_Growth[i] = 4900
  } else if (urban$Pop_Bin[i] == '6') {
    urban$High_Density_Growth[i] = 6000  
  } else urban$High_Density_Growth[i] = 7200
}
urban = as.data.frame(urban)
# Reorganize data to have a column of density options that makes the data cleaner
urban = urban %>%
  rename(Low = Low_Density_Growth) %>%
  rename(Medium = Medium_Density_Growth) %>%
  rename(High = High_Density_Growth) %>%
  gather(Density_Option, Density_Growth, c(-WaterProvider, -County, -Year, -WaterDistrict_Population, 
                                           -Annual_Pop_Diff, -Pop_Bin))


# 7) Calculate new land growth by dividing 'Annual_Pop_Diff' by each of the three density options.  Units are square 
#    miles
land_growth_urban = urban %>%
  mutate(Growth_Area_sqmiles = Annual_Pop_Diff / Density_Growth)


# 8) Calculate the cumulative amount of new growth each year by adding each year's growth to the water district areas 
#    from 2018 given in the original 'density' dataset.
total_growth_urban = land_growth_urban %>%
  group_by(WaterProvider, County, Density_Option) %>%
  mutate(Cumulative_Growth_sqmiles = cumsum(Growth_Area_sqmiles)) %>%
  rename(New_Growth_sqmiles = Growth_Area_sqmiles) %>%
  dplyr::select(-WaterDistrict_Population, -Annual_Pop_Diff, -Pop_Bin, -Density_Growth)
total_growth_urban = as.data.frame(total_growth_urban)


# 9) Merge 'total_growth_urban' with 'district_land'.  Will use 'Area_sqmiles' column for each district and add it to 
# the 'Cumulative_Land_Growth' column to get the total amount of land area of each urban water district for each year.
total_growth_urban = left_join(total_growth_urban, district_land, by = c("WaterProvider", "County"))
total_growth_urban = total_growth_urban %>%
  mutate(Total_Land_Area_sqmiles = Cumulative_Growth_sqmiles + Area_sqmiles) %>%
  dplyr::select(-Area_sqmiles)


# 10) Consider district build-out as was done for municipalities.

# Read back in 'waterdistrict-land-development.csv'.  Here, each water district was summarized by how much land is 
# developed, potentially developable, or not developable.
district_develop = read.csv('..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\waterdistrict-land-development.csv', header = TRUE)
head(district_develop)
# Calculate maximum amount of land area growth possible, which is Developed + Potentially Developable.  This equates 
# to district build-out
district_develop = district_develop %>%
  filter(LandDevelopment != "Not Developable") %>%
  group_by(WaterProvider, County) %>%
  summarize(BuildOutArea = sum(Area_sqmiles))
district_develop = as.data.frame(district_develop)
# So conclusion should be that any district whose growth area for a given year is greater than the BuildOutArea 
# from 'district_develop' should change the area (Total_Land_Area_sqmiles) to the BuildOutArea value.  Then 
# 'New_Growth_sqmiles' should be changed to 0 and 'Cumulative_Growth_sqmiles' recalculated accordingly.

# Join 'district_develop' with 'total_growth_urban'
total_growth_urban = left_join(total_growth_urban, district_develop, by = c("WaterProvider" = "WaterProvider", 
                                                                            "County" = "County"))

# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set Total_Land_Area_sqmiles to equal BuildOutArea.
for (i in 1:length(total_growth_urban$Total_Land_Area_sqmiles)) {
  if (total_growth_urban$Total_Land_Area_sqmiles[i] > total_growth_urban$BuildOutArea[i]) {
    total_growth_urban$Total_Land_Area_sqmiles[i] = total_growth_urban$BuildOutArea[i]
  } else total_growth_urban$Total_Land_Area_sqmiles[i] = total_growth_urban$Total_Land_Area_sqmiles[i]
}
# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set New_Growth_sqmiles to 0 and recalculate cumulative
for (i in 1:length(total_growth_urban$Total_Land_Area_sqmiles)) {
  if (total_growth_urban$Total_Land_Area_sqmiles[i] == total_growth_urban$BuildOutArea[i]) {
    total_growth_urban$New_Growth_sqmiles[i] = 0
  } else total_growth_urban$New_Growth_sqmiles[i] = total_growth_urban$New_Growth_sqmiles[i]
}
# Recalculate Cumulative_Growth
total_growth_urban = total_growth_urban %>%
  group_by(WaterProvider, County, Density_Option) %>%
  mutate(New_Cumulative_Growth = cumsum(New_Growth_sqmiles)) %>%
  dplyr::select(-Cumulative_Growth_sqmiles) %>%
  rename(Cumulative_Growth_sqmiles = New_Cumulative_Growth) %>%
  # Reorganize
  dplyr::select(WaterProvider, County, Year, Density_Option, New_Growth_sqmiles, Cumulative_Growth_sqmiles, 
                Total_Land_Area_sqmiles, BuildOutArea)


# 11) Summarize new land growth of urban water districts by county considering district build-out.
land_growth_summary_urban = total_growth_urban %>%
  group_by(County, Year, Density_Option) %>%
  summarize(Land_Growth_sqmiles = sum(Cumulative_Growth_sqmiles)) %>%
  mutate(Land_Growth_acres = Land_Growth_sqmiles * 640) %>%
  arrange(County, Density_Option, Year)
land_growth_summary_urban = as.data.frame(land_growth_summary_urban)


# 12) Summarize total urban water district land area by county considering district build-out.
total_land_summary_urban = total_growth_urban %>%
  group_by(County, Year, Density_Option) %>%
  summarize(Total_WaterDistrict_Land_sqmiles = sum(Total_Land_Area_sqmiles)) %>%
  mutate(Total_WaterDistrict_Land_acres = Total_WaterDistrict_Land_sqmiles * 640) %>%
  arrange(County, Density_Option, Year)
total_land_summary_urban = as.data.frame(total_land_summary_urban)


# RURAL DISTRICTS
# 13) Density-of-growth assumptions:  WestWater Research stated that for rural districts, the county's specific 
# population density was used, but did not mention options for density, such as OWF has done so far with Low, 
# Medium and High assumptions.  For now, OWF is assuming that there are NOT density options for rural districts and 
# will use the unincorporated county density for 2018 up to 2050.  Thus, when this data is merged with other data,
# density options will use the same values.

# Merge 'county_density with 'rural'
rural = left_join(rural, county_density, by = c("County" = "County"))


# 14) Calculate new land growth by dividing 'Annual_Pop_Diff' by 'Density.  Units are square 
#    miles
land_growth_rural = rural %>%
  mutate(Growth_Area_sqmiles = Annual_Pop_Diff / Density)
land_growth_rural = as.data.frame(land_growth_rural)
# Delete NAs because they relate to Broomfield County unincorporated area, which doesn't have any population
land_growth_rural = na.omit(land_growth_rural)


# 15) Calculate the cumulative amount of new growth each year by adding each year's growth 
#    to the water district areas from 2018 given in the original 'district_land' dataset.
total_growth_rural = land_growth_rural %>%
  group_by(WaterProvider, County) %>%
  mutate(Cumulative_Growth_sqmiles = cumsum(Growth_Area_sqmiles)) %>%
  rename(New_Growth_sqmiles = Growth_Area_sqmiles) %>%
  dplyr::select(WaterProvider, County, Year, New_Growth_sqmiles, Cumulative_Growth_sqmiles)
total_growth_rural = as.data.frame(total_growth_rural)


# 16) Merge 'total_growth_rural' with 'district_land'.  Will use 'Area_sqmiles' column for each district and add it to the 
#    'Cumulative_Land_Growth' column to get the total amount of land area of each rural water district for each year.
total_growth_rural = left_join(total_growth_rural, district_land, by = c("WaterProvider", "County"))
total_growth_rural = total_growth_rural %>%
  mutate(Total_Land_Area_sqmiles = Cumulative_Growth_sqmiles + Area_sqmiles) %>%
  dplyr::select(-Area_sqmiles)


# 17) Consider district build-out as was done for municipalities and urban districts.  use the 'district-develop' 
# dataset again.
# Join 'district_develop' with 'total_growth_rural'
total_growth_rural = left_join(total_growth_rural, district_develop, by = c("WaterProvider" = "WaterProvider", 
                                                                            "County" = "County"))

# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set Total_Land_Area_sqmiles to equal BuildOutArea.
for (i in 1:length(total_growth_rural$Total_Land_Area_sqmiles)) {
  if (total_growth_rural$Total_Land_Area_sqmiles[i] > total_growth_rural$BuildOutArea[i]) {
    total_growth_rural$Total_Land_Area_sqmiles[i] = total_growth_rural$BuildOutArea[i]
  } else total_growth_rural$Total_Land_Area_sqmiles[i] = total_growth_rural$Total_Land_Area_sqmiles[i]
}
# If Total_Land_Area_sqmiles is greater than BuildoutArea, then set New_Growth_sqmiles to 0 and recalculate cumulative
for (i in 1:length(total_growth_rural$Total_Land_Area_sqmiles)) {
  if (total_growth_rural$Total_Land_Area_sqmiles[i] == total_growth_rural$BuildOutArea[i]) {
    total_growth_rural$New_Growth_sqmiles[i] = 0
  } else total_growth_rural$New_Growth_sqmiles[i] = total_growth_rural$New_Growth_sqmiles[i]
}
# Recalculate Cumulative_Growth
total_growth_rural = total_growth_rural %>%
  group_by(WaterProvider, County) %>%
  mutate(New_Cumulative_Growth = cumsum(New_Growth_sqmiles)) %>%
  dplyr::select(-Cumulative_Growth_sqmiles) %>%
  rename(Cumulative_Growth_sqmiles = New_Cumulative_Growth) %>%
  # Reorganize
  dplyr::select(WaterProvider, County, Year, New_Growth_sqmiles, Cumulative_Growth_sqmiles, 
                Total_Land_Area_sqmiles, BuildOutArea)


# 18) Summarize new land growth of rural water districts by county considering district build-out.
land_growth_summary_rural = total_growth_rural %>%
  group_by(County, Year) %>%
  summarize(Land_Growth_sqmiles = sum(Cumulative_Growth_sqmiles)) %>%
  mutate(Land_Growth_acres = Land_Growth_sqmiles * 640) %>%
  arrange(County, Year)
land_growth_summary_rural = as.data.frame(land_growth_summary_rural)


# 19) Summarize total rural water district land area by county considering district build-out.
total_land_summary_rural = total_growth_rural %>%
  group_by(County, Year) %>%
  summarize(Total_WaterDistrict_Land_sqmiles = sum(Total_Land_Area_sqmiles)) %>%
  mutate(Total_WaterDistrict_Land_acres = Total_WaterDistrict_Land_sqmiles * 640) %>%
  arrange(County, Year)
total_land_summary_rural = as.data.frame(total_land_summary_rural)


# 20) Combine urban and rural datasets
# First need to create density options for rural districts
total_growth_rural_low = total_growth_rural
total_growth_rural_low$Density_Option = "Low"
total_growth_rural_medium = total_growth_rural
total_growth_rural_medium$Density_Option = "Medium"
total_growth_rural_high = total_growth_rural
total_growth_rural_high$Density_Option = "High"
# Merge together
total_growth_rural  = full_join(total_growth_rural_low, total_growth_rural_medium)
total_growth_rural  = full_join(total_growth_rural, total_growth_rural_high)
total_growth  = full_join(total_growth_urban, total_growth_rural)


# 21) Summarize new land growth for both municipalities and water districts by county and compare to Table 4 
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


# 22) Export data
# Export 'total_growth' to folder '11-Map-LandDevelopment' to convert new growth in square miles to raster cells
write.csv(total_growth, "..\\11-Map-LandDevelopment\\district-land-area-growth.csv", row.names = FALSE)


# 23) Create graphs of growth and total land by county for urban and rural districts
ggplot(land_growth_summary_urban, aes(x = Year, y = Land_Growth_sqmiles, color = County)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

ggplot(total_land_summary_urban, aes(x = Year, y = Total_WaterDistrict_Land_sqmiles, color = County)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

ggplot(land_growth_summary_rural, aes(x = Year, y = Land_Growth_sqmiles, color = County)) +
  geom_line()

ggplot(total_land_summary_rural, aes(x = Year, y = Total_WaterDistrict_Land_sqmiles, color = County)) +
  geom_line()


# Split 'total_growth_urban' and 'total_growth_rural' into separate datasets by county and then graph for 
# quality-control purposes
# TODO:  maybe add more graphs here
adams = total_growth_urban %>%
  filter(County == "Adams")
ggplot(adams, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)
# Nothing rural for Adams

arapahoe = total_growth_urban %>%
  filter(County == "Arapahoe")
ggplot(arapahoe, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)
# Nothing rural for Arapahoe

# Nothing urban for Boulder
boulder = total_growth_rural %>%
  filter(County == "Boulder")
ggplot(boulder, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

douglas = total_growth_urban %>%
  filter(County == "Douglas")
ggplot(douglas, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

douglas = total_growth_rural %>%
  filter(County == "Douglas")
ggplot(douglas, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

# Nothing urban or rural for Elbert

elpaso = total_growth_urban %>%
  filter(County == "El Paso")
ggplot(elpaso, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)
# Nothing rural for El Paso

jefferson = total_growth_urban %>%
  filter(County == "Jefferson")
ggplot(jefferson, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)
# Nothing rural for Jefferson

larimer = total_growth_urban %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

larimer = total_growth_rural %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

pueblo = total_growth_urban %>%
  filter(County == "Pueblo")
ggplot(pueblo, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

pueblo = total_growth_rural %>%
  filter(County == "Pueblo")
ggplot(pueblo, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()

# Nothing urban for Weld
weld = total_growth_rural %>%
  filter(County == "Weld")
ggplot(weld, aes(x = Year, y = Cumulative_Growth_sqmiles, color = WaterProvider)) +
  geom_line()
