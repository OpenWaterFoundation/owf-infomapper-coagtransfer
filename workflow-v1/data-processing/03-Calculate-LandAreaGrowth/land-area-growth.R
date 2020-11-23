# Calculation of new land area development for municipalities

# Land area growth will use population estimates for municipalities split by county as necessary.

# BACKGROUND:  from WestWater Research's report (p.15), land area development estimates were made by taking the 
# municipal population projections and applying an estimated population density (persons per square mile). Population 
# density was estimated to increase as municipalities grow and urbanize. A scatterplot of population vs. density was 
# used to develop seven different density assumptions based on population.  These are replicated in 
# in this script.
# As an example, if a municipality with a population of 35,000 grows by 3,000 people in a year, the associated new land 
# development area is estimated to be 3,000/2,700 = 1.11 square miles (710 acres).  The 2700 number comes from a 
# medium density assumption for a municipality with a population between 20,000 and 50,000.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd("E:\\Data\\data-processing\\03-Calculate-LandAreaGrowth\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "land-area-growth.R"
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
# Filter out unincorporated areas; they will be addressed later
pop = pop %>%
  filter(!grepl("Unincorporated Area", MunicipalityName))
  
# b. Read in population density data calculate in 02-Calculate-PopulationDensity
density = read.csv("population-density.csv", header=TRUE)
head(density)


#2) Calculate the difference in population from one year to the next
pop = pop %>%
  group_by(MunicipalityName, County) %>%
  mutate(Annual_Pop_Diff = Municipal_Population - lag(Municipal_Population)) %>%
  arrange(MunicipalityName, County)
# Change NAs to 0 to indicate no change
pop$Annual_Pop_Diff[is.na(pop$Annual_Pop_Diff)] = 0

# 3) Create population bins
# WestWater Research created population bins in which to assign density categories.  Replicate the bins.
for (i in 1:length(pop$Municipal_Population)) {
  if (pop$Municipal_Population[i] > 500000) {
    pop$Pop_Bin[i] = '7'
  } else if (pop$Municipal_Population[i] <= 500000 & pop$Municipal_Population[i] > 100000) {
    pop$Pop_Bin[i] = '6'
  } else if (pop$Municipal_Population[i] <= 100000 & pop$Municipal_Population[i] > 50000) {
    pop$Pop_Bin[i] = '5'
  } else if (pop$Municipal_Population[i] <= 50000 & pop$Municipal_Population[i] > 20000) {
    pop$Pop_Bin[i] = '4'
  } else if (pop$Municipal_Population[i] <= 20000 & pop$Municipal_Population[i] > 10000) {
    pop$Pop_Bin[i] = '3'
  } else if (pop$Municipal_Population[i] <= 10000 & pop$Municipal_Population[i] > 5000) {
    pop$Pop_Bin[i] = '2'  
  } else pop$Pop_Bin[i] = '1'
}


# 4) Assign density-of-growth assumptions
# WestWater Research, after creating the population bins, assigned estimated population densities for 
# each bin.  These can be found in the "Assumptions & Description" worksheet of "Front Range Population & Land 
# Area Projections (DRCOG).xlsx".  There are 3 options for density of growth; will use low, medium and high
# designations and assign to each municipality based on its population bin category.
# The density options will be used to calculate new land development area for each year.

# Create low density of growth
for (i in 1:length(pop$Pop_Bin)) {
  if (pop$Pop_Bin[i] == '1') {
    pop$Low_Density_Growth[i] = 500
  } else if (pop$Pop_Bin[i] == '2') {
    pop$Low_Density_Growth[i] = 750
  } else if (pop$Pop_Bin[i] == '3') {
    pop$Low_Density_Growth[i] = 1100
  } else if (pop$Pop_Bin[i] == '4') {
    pop$Low_Density_Growth[i] = 1500
  } else if (pop$Pop_Bin[i] == '5') {
    pop$Low_Density_Growth[i] = 2000
  } else if (pop$Pop_Bin[i] == '6') {
    pop$Low_Density_Growth[i] = 3000  
  } else pop$Low_Density_Growth[i] = 4000
}

# Create medium density of growth
for (i in 1:length(pop$Pop_Bin)) {
  if (pop$Pop_Bin[i] == '1') {
    pop$Medium_Density_Growth[i] = 1000
  } else if (pop$Pop_Bin[i] == '2') {
    pop$Medium_Density_Growth[i] = 1400
  } else if (pop$Pop_Bin[i] == '3') {
    pop$Medium_Density_Growth[i] = 2000
  } else if (pop$Pop_Bin[i] == '4') {
    pop$Medium_Density_Growth[i] = 2700
  } else if (pop$Pop_Bin[i] == '5') {
    pop$Medium_Density_Growth[i] = 3500
  } else if (pop$Pop_Bin[i] == '6') {
    pop$Medium_Density_Growth[i] = 4400  
  } else pop$Medium_Density_Growth[i] = 5400
}

# Create high density of growth
for (i in 1:length(pop$Pop_Bin)) {
  if (pop$Pop_Bin[i] == '1') {
    pop$High_Density_Growth[i] = 1500
  } else if (pop$Pop_Bin[i] == '2') {
    pop$High_Density_Growth[i] = 2200
  } else if (pop$Pop_Bin[i] == '3') {
    pop$High_Density_Growth[i] = 3000
  } else if (pop$Pop_Bin[i] == '4') {
    pop$High_Density_Growth[i] = 3900
  } else if (pop$Pop_Bin[i] == '5') {
    pop$High_Density_Growth[i] = 4900
  } else if (pop$Pop_Bin[i] == '6') {
    pop$High_Density_Growth[i] = 6000  
  } else pop$High_Density_Growth[i] = 7200
}
pop = as.data.frame(pop)

# Reorganize data to have a column of density options that makes the data cleaner
pop = pop %>%
  rename(Low = Low_Density_Growth) %>%
  rename(Medium = Medium_Density_Growth) %>%
  rename(High = High_Density_Growth) %>%
  gather(Density_Option, Density_Growth, c(-MunicipalityName, -County, -Year, -Municipal_Population, 
                                           -Annual_Pop_Diff, -Pop_Bin))


# 5) Calculate new land growth by dividing 'Annual_Pop_Diff' by each of the three density options.  Units are square 
#    miles
land_growth = pop %>%
  mutate(Growth_Area_sqmiles = Annual_Pop_Diff / Density_Growth)
# If the annual population difference is negative (population is decreasing), replace negative growth with 0.  
# Assumption is that a decreasing population does not expand its area (and area can't be negative).
land_growth$Growth_Area_sqmiles = replace(land_growth$Growth_Area_sqmiles, land_growth$Growth_Area_sqmiles < 0, 0)


# 6) Calculate the cumulative amount of new growth each year by adding each year's growth to the municipal areas from 
#    2018 given in the original' density' dataset.
total_growth = land_growth %>%
  group_by(MunicipalityName, County, Density_Option) %>%
  mutate(Cumulative_Growth_sqmiles = cumsum(Growth_Area_sqmiles)) %>%
  rename(New_Growth_sqmiles = Growth_Area_sqmiles) %>%
  dplyr::select(MunicipalityName, Year, County, Density_Option, New_Growth_sqmiles, Cumulative_Growth_sqmiles) %>%
  arrange(MunicipalityName, County, Year)
total_growth = as.data.frame(total_growth)


# 7) Merge 'total_growth' with 'density'.  Will use 'Area_2018' column for each municipality and add it to the 
#    'Cumulative_Growth' column to get the total amount of land area of each muni for each year.
total_growth = left_join(total_growth, density, by = c("MunicipalityName", "County"))
total_growth = total_growth %>%
  mutate(Total_Land_Area_sqmiles = Cumulative_Growth_sqmiles + Area_2018) %>%
  dplyr::select(-Population_2018, -Area_2018, -Density)
# Set NAs to 0 for Total_Land_Area_sqmiles for those munis that don't have developed land
total_growth[is.na(total_growth)] = 0

# 8) Consider municipal build-out.
# From WestWater Research's report (p. 15): "For some municipalities, additional population growth could not be 
# accommodated by increasing the developed land area within the municipal boundary. In these cases of municipal 
# build out, additional population growth was assumed to occur through increased population density within the 
# built-out boundary of the municipality and the population density estimates were not applied."

# Read in data calculated in '01-Calculate-Municipal-WaterDistrictAreas', 'municipal-land-development.csv'.  Here, 
# each municipality was summarized by how much land is developed, potentially developable, or not developable.
muni_develop = read.csv('..\\02-Calculate-PopulationDensity\\municipal-land-development.csv', header = TRUE)
head(muni_develop)
# Calculate maximum amount of land area growth possible, which is Developed + Potentially Developable.  This equates 
# to municipal build-out
muni_develop = muni_develop %>%
  filter(LandDevelopment != "Not Developable") %>%
  group_by(Municipality, County) %>%
  summarize(BuildOutArea = sum(Area_sqmiles))
muni_develop = as.data.frame(muni_develop)
# So conclusion should be that any municipality whose growth area for a given year is greater than the BuildOutArea 
# from 'muni_develop' should change the area (Total_Land_Area_sqmiles) to the BuildOutArea value.  Then 
# 'New_Growth_sqmiles' should be changed to 0 and 'Cumulative_Growth_sqmiles' recalculated accordingly.

# Join 'muni_develop' with 'total_growth'
total_growth = left_join(total_growth, muni_develop, by = c("MunicipalityName" = "Municipality", "County" = "County"))

# Manual edit:  Thornton is listed in Weld County for population numbers, yet the totals are always zero.  And since
# Thornton is not within Weld County, will delete this set of values (Thornton, Weld)
total_growth = total_growth %>%
  filter(MunicipalityName != "Thornton" | County != "Weld")

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
  group_by(MunicipalityName, County, Density_Option) %>%
  mutate(New_Cumulative_Growth = cumsum(New_Growth_sqmiles)) %>%
  dplyr::select(-Cumulative_Growth_sqmiles) %>%
  rename(Cumulative_Growth_sqmiles = New_Cumulative_Growth) %>%
  # Reorganize
  dplyr::select(MunicipalityName, County, Year, Density_Option, New_Growth_sqmiles, Cumulative_Growth_sqmiles, 
                Total_Land_Area_sqmiles, BuildOutArea)


# 9) Summarize new land growth of municipalities by county considering municipal build-out.
land_growth_summary = total_growth %>%
  group_by(County, Year, Density_Option) %>%
  summarize(Land_Growth_sqmiles = sum(Cumulative_Growth_sqmiles)) %>%
  mutate(Land_Growth_acres = Land_Growth_sqmiles * 640) %>%
  arrange(County, Density_Option, Year)
land_growth_summary = as.data.frame(land_growth_summary)


# 10) Summarize total municipal land area by county considering municipal build-out.
total_land_summary = total_growth %>%
  group_by(County, Year, Density_Option) %>%
  summarize(Total_Municipal_Land_sqmiles = sum(Total_Land_Area_sqmiles)) %>%
  mutate(Total_Municipal_Land_acres = Total_Municipal_Land_sqmiles * 640) %>%
  arrange(County, Density_Option, Year)
total_land_summary = as.data.frame(total_land_summary)


# 11) Export data
# Export 'total_growth' to folder '04-Calculate-FutureMunicipalDensity' so that calculations of future population density can be done.
write.csv(total_growth, "..\\04-Calculate-FutureMunicipalDensity\\municipal-land-area-growth.csv", row.names = FALSE)


# 12) Create graphs of growth and total land
ggplot(land_growth_summary, aes(x = Year, y = Land_Growth_acres, color = County)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

ggplot(total_land_summary, aes(x = Year, y = Total_Municipal_Land_sqmiles, color = County)) +
  geom_line() +
  facet_grid(. ~ Density_Option)


# Split 'total_growth' into separate datasets by county and then graph for quality-control purposes
adams = total_growth %>%
  filter(County == "Adams")
ggplot(adams, aes(x = Year, y = Total_Land_Area_sqmiles, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

arapahoe = total_growth %>%
  filter(County == "Arapahoe")
ggplot(arapahoe, aes(x = Year, y = Total_Land_Area_sqmiles, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

larimer = total_growth %>%
  filter(County == "Larimer")
ggplot(larimer, aes(x = Year, y = Total_Land_Area_sqmiles, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)

pueblo = total_growth %>%
  filter(County == "Pueblo")
ggplot(pueblo, aes(x = Year, y = Total_Land_Area_sqmiles, color = MunicipalityName)) +
  geom_line() +
  facet_grid(. ~ Density_Option)
