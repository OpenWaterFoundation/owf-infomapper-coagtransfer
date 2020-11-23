# Calculation of proportion of municipal population within each county
# for the years 2018-2050 since there are no population forecasts for municipalities in Colorado.

# Per discussion with Brett Bovee on 7/8/19, will use only 2017 data to calculate the proportions.
# In the previous version, an average proportion was used based on data from 2010-2017.  The proportions
# can perhaps be altered or a set of options provided in a future version of the analysis.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
#setwd ("E:\\Data\\data-processing\\00-Calculate-PopulationProjections\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "municipal-population-proportions.R"
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

# 1) Read in datasets
counties = read.csv("county-population.csv", header = TRUE)
# Make sure population data are numeric
counties$Population = as.numeric(counties$Population)
munis = read.csv("municipal-population.csv", header = TRUE)

# Rename some columns so it's clear which population numbers are which and filter datasets to 2017
counties = counties %>%
  rename(County_Population = Population) %>%
  filter(Year == 2017)
munis = munis %>%
  rename(Municipal_Population = Population) %>%
  filter(Year == 2017)
head(counties)
head(munis)


# 2) Join datasets
muni_county = left_join(munis, counties, by = c("County", "Year"))


# 3) Summarize population by county to find the remainder, which will be counted as "Unincorporated Area"
unincorp = muni_county %>%
  group_by(County, Year) %>%
  summarize(Total_Municipal_Pop = sum(Municipal_Population))
# Join with county data
unincorp = left_join(unincorp, counties, by = c("County", "Year"))
# Create new column that is the county population minus the summed municipal populations
unincorp = unincorp %>%
  mutate(Unincorporated_Population = County_Population - Total_Municipal_Pop) %>%
  # Reorganize data to match format of muni_county so that data can be appended
  dplyr::select(County, Year, Unincorporated_Population, County_Population) %>%
  rename(Municipal_Population = Unincorporated_Population) %>%
  mutate(MunicipalityName = paste(County, "County Unincorporated Area"))
# Join with muni_county dataset
muni_county = full_join(muni_county, unincorp)  


# 4) Calculate proportion of county pop that is the municipality or unincorporated area
muni_county = muni_county %>%
  mutate(Proportion_of_County = Municipal_Population / County_Population) %>%
  arrange(County) %>% # Sort by county
  dplyr::select(MunicipalityName, County, Proportion_of_County) # Keep only needed columns
muni_county = as.data.frame(muni_county)

# Export average proportions as a data check
write.csv(muni_county, "..\\..\\data-processing\\00-Calculate-PopulationProjections\\municipal-proportions.csv", row.names = FALSE)


# 5) Calculate municipal populations from 2018 to 2050 by dividing county populations by proportion for 
#    each municipality/unincorporated area
# Read back in original county dataset
county_forecast = read.csv("county-population.csv", header = TRUE)
# Make sure population data are numeric
county_forecast$Population = as.numeric(county_forecast$Population)
# Filter dataset to exclude years prior to 2018
county_forecast = county_forecast %>%
  filter(Year > 2017) %>%
  rename(County_Population = Population) # Be more specific about column name

# Join the avg_muni_county and counties datasets by the "County" columns in each
muni_forecast = left_join(muni_county, county_forecast)

# Calculate municipal population by multiplying "County_Population" by "Proportion_of_County"
muni_forecast = muni_forecast %>%
  mutate(Municipal_Population = County_Population * Proportion_of_County) %>%
  # Filter dataset to only counties/munis of interest
  filter(County %in% c("Adams", "Arapahoe", "Boulder", "Broomfield", "Denver", "Douglas", "El Paso", "Elbert",
                       "Jefferson", "Larimer", "Pueblo", "Weld")) %>%
  filter(!MunicipalityName %in% c("Estes Park", "Jamestown", "Ward", "Lyons", "Nederland", "Green Mountain Falls", 
                                  "Rye"))
# Round population to whole numbers
muni_forecast$Municipal_Population = round(muni_forecast$Municipal_Population, digits = 0)
# Omit NAs because these are for counties not being analyzed
muni_forecast = na.omit(muni_forecast)


# 6) Simplify dataset by removing some columns and sort by municipality
muni_forecast = muni_forecast %>%
  dplyr::select(MunicipalityName, County, Year, Municipal_Population) %>%
  arrange(MunicipalityName, County, Year)


# 7) Export dataset
output_file = "municipal-population-forecast.csv"
cat("Writing county population file: ", output_file, "\n")
write.csv(muni_forecast, output_file , row.names = FALSE)

