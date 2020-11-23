# Calculation of future population densities of municipalities

# Will use the total land area calculations from '03-Calculate-LandAreaGrowth' and the municipal population forecast data
# from '00-Calculate-PopulationProjections' to calculate future population densities.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\04-Calculate-FutureMunicipalDensity\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "future-municipal-density.R"
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
# a. Read in municipal population forecast data from 00-Calculate-PopulationProjections
pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv", header=TRUE)
head(pop)
# Filter out unincorporated areas
pop = pop %>%
  filter(!grepl("Unincorporated Area", MunicipalityName))

# b. Read in land area growth data calculated in 03-Calculate-LandAreaGrowth\\land-area-growth.R
land = read.csv("municipal-land-area-growth.csv", header=TRUE)
head(land)
# Will use the 'Total_Land_Area_sqmiles' column that indicates total land area, not the 
# cumulative growth column that calculated the amount of growth per year.


# 2) Join 'pop' to 'land' to have population data associated with each municipality for each year and each density 
# option
future_density = left_join(land, pop, by = c("MunicipalityName", "County", "Year"))


# 3) Calculate density in square miles
future_density = future_density %>%
  mutate(Density = Municipal_Population / Total_Land_Area_sqmiles) %>%
  arrange(MunicipalityName, Year, Density_Option)


# 4) Export to folder `05-Calculate-WaterDistrictPopulation`
write.csv(future_density, "..\\05-Calculate-WaterDistrictPopulation-withinMunis\\future-municipal-density.csv", row.names = FALSE)


# 5) Create graphs for quality control
# Graph by county 
adams = future_density %>%
  filter(County == "Adams")
ggplot(adams, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

arapahoe = future_density %>%
  filter(County == "Arapahoe")
ggplot(arapahoe, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

boulder = future_density %>%
  filter(County == "Boulder")
ggplot(boulder, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

douglas = future_density %>%
  filter(County == "Douglas")
ggplot(douglas, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

elpaso = future_density %>%
  filter(County == "El Paso")
ggplot(elpaso, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

jefferson = future_density %>%
  filter(County == "Jefferson")
ggplot(jefferson, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

larimer = future_density %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

pueblo = future_density %>%
  filter(County == "Pueblo")
ggplot(pueblo, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

weld = future_density %>%
  filter(County == "Weld")
ggplot(weld, aes(x = Year, y = Density, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)



