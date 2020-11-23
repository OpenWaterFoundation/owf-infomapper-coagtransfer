# Check population totals
# Summarize municipal and water district population estimates and compare to county estimates to make sure estimates 
# look good.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\09-Check-Population\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "check-population.R"
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
# a. Read in municipal population estimates
muni_pop = read.csv("..\\10-Calculate-Demand\\municipal-population.csv", header=TRUE)
head(muni_pop)

# b. Read in water district population estimates
district_pop = read.csv("..\\10-Calculate-Demand\\waterdistrict-population.csv", header=TRUE)
head(district_pop)

# c. Read in county population estimates from DOLA
county_pop = read.csv("..\\00-Calculate-PopulationProjections\\county-population.csv", header=TRUE)
# Filter to 2018 and later
county_pop = county_pop %>%
  filter(Year >= 2018)
head(county_pop)


# 2) Join muni_pop and district_pop and summarize population by county
# Rename columns so that they match
muni_pop = muni_pop %>%
  rename(Entity = MunicipalityName, Population = Municipal_Population)
district_pop = district_pop %>%
  rename(Entity = WaterProvider)
total_pop = full_join(muni_pop, district_pop)
# Summarize
total_pop = total_pop %>%
  group_by(County, Year) %>%
  summarize(Population = sum(Population))
total_pop = as.data.frame(total_pop)


# 3) Join 'county_pop' to 'total_pop' to compare population estimates
compare = left_join(total_pop, county_pop, by = c("County" = "County", "Year" = "Year"))
# Calculate the difference (Population.y - Population.x); should be greater than 0, which indicates some population
# in neither municipalities nor water districts under consideration.  Remember that not all water districts were 
# analyzed, particularly the more urban ones around Denver.
compare = compare %>%
  mutate(Difference = Population.y - Population.x)
# RESULT: ALL DIFFERENCES ARE GREATER THAN 0.

