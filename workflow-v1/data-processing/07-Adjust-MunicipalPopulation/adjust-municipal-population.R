# Adjust municipal population estimates based on water district populations

# Water provider (district) populations were calculated in 
# '05-Calculate-WaterDistrictPopulation-withinMunis\\waterdistrict-population-municipal.R'.  Since the water 
# districts can overlap municipal boundaries, population was calculated as a proportion of that overlap.  
# Thus, population needs to be lowered accordingly for municipalities. 

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\07-Adjust-MunicipalPopulation\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "adjust-municipal-population.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr)  # For data manipulation and clean-up
library(tidyr)  # For data manipulation and clean-up

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1) Read in data
# a. Read in municipal population estimates as provided in '00-Calculate-PopulationProjections'.
muni_pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv", header=TRUE)
head(muni_pop)

# b. Read in the portion of district population that can be attributed to a municipality, as calculated in 
# '05-Calculate-WaterDistrictPopulation-withinMunis\\waterdistrict-population-municipal.R'
district_muni_pop = read.csv("district-municipal-population.csv", header=TRUE)
head(district_muni_pop)


# 2) Filter 'muni_pop' into municipalities only
muni = muni_pop %>%
  filter(!grepl("Unincorporated Area", MunicipalityName))


# 3) Summarize 'district_muni_pop' by municipality/county combo
district_muni_pop = district_muni_pop %>%
  group_by(Municipality, County, Year) %>%
  summarize(WaterDistrict_Population = sum(WaterDistrict_Population))

# 4) Join 'district_muni_pop' to 'muni'
muni2 = left_join(muni, district_muni_pop, by = c("MunicipalityName" = "Municipality", "County" = "County", 
                                                  "Year" = "Year"))
# Change NAs to 0 since NA means that there is no water district population for that muni/county combo
muni2[is.na(muni2)] = 0


# 5) Calculate new population by subtracting 'WaterDistrict_Population' from 'Municipal_Population'
muni2 = muni2 %>%
  mutate(New_Pop = Municipal_Population - WaterDistrict_Population) %>%
  dplyr::select(-Municipal_Population, -WaterDistrict_Population) %>%
  rename(Municipal_Population = New_Pop) %>%
  arrange(MunicipalityName, County, Year)
# THESE ARE THE NEW MUNICIPAL POPULATION ESTIMATES AND SHOULD BE USED GOING FORWARD.


# 6) Export data to folder '10-Calculate-Demand' to calculate water demand
write.csv(muni2, '..\\10-Calculate-Demand\\municipal-population.csv', row.names = FALSE)

