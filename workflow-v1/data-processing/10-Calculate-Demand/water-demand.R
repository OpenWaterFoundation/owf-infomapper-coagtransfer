# Calculate water demand of municipalities and water districts

# GPCD estimates were provided by WestWater Research and were compiled from reports specific to each 
# municipality/water district.  WestWater Research obtained GPCD estimates for about 40% of analyzed water providers, 
# representing about 80% of the population.  For some municipalities and water districts that did not have a reported 
# GPCD, WestWater Research made an estimate based on other water providers with a similar service size and proximal 
# location.  
# ** Note that there are approximately 40 municipalities and water districts that do not have GPCD estimates, so 
# demand could not be calculated for these entities.**  Therefore, the analysis beyond this point is confined to fewer
# entities than shown in the master list and that for which population projections were made.

# The GPCD estimates compiled as described above are considered 'normal' estimates.  Two other GPCD estimates, 
# categorized as 'efficient' and 'inefficient' were considered.  An efficient GPCD was calculated as the normal GPCD 
# multiplied by 0.85.  An inefficient GPCD was calculated as the normal GPCD multiplied by 1.15.  Therefore, 
# three sets of demand estimates are calculated for municipalities and water districts depending on the level of water 
# use efficiency.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\10-Calculate-Demand\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "water-demand.R"
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
muni_pop = read.csv("municipal-population.csv", header=TRUE)
head(muni_pop)

# b. Read in water district population estimates
district_pop = read.csv("waterdistrict-population.csv", header=TRUE)
head(district_pop)

# c. Read in 'gpcd.csv', which lists water use estimates for municipalities and water districts.  Normal, efficient, 
# and inefficient estimates are included.
gpcd = read.csv("gpcd.csv", header=TRUE)
head(gpcd)


# 2) Join municipal and water district population datasets together to have one dataset to work with.
# First change 'MunicipalityName' to 'WaterProvider' and change 'Municipal_Population' to just 'Population'
muni_pop = muni_pop %>%
  rename(WaterProvider = MunicipalityName, Population = Municipal_Population)
# Join datasets
provider_pop = full_join(muni_pop, district_pop)


# 3) Link 'gpcd' to 'provider_pop' in order to calculate demand
demand = left_join(provider_pop, gpcd, by = c("WaterProvider" = "Water_Provider"))


# 4) Calculate demand for each gpcd scenario; units are gallons per year
demand_gpy = demand %>%
  mutate(Normal_Demand_gpy = Population * Normal_GPCD * 365) %>%
  mutate(Efficient_Demand_gpy = Population * Efficient_GPCD * 365) %>%
  mutate(Inefficient_Demand_gpy = Population * Inefficient_GPCD * 365)
# Get rid of NAs because these are providers that do not have gpcds
demand_gpy = na.omit(demand_gpy)


# 5) Convert demand to acre-feet per year
demand_afy = demand_gpy %>%
  mutate(Normal_Demand_afy = Normal_Demand_gpy * 0.00000306889) %>%
  mutate(Efficient_Demand_afy = Efficient_Demand_gpy * 0.00000306889) %>%
  mutate(Inefficient_Demand_afy = Inefficient_Demand_gpy * 0.00000306889) %>%
  dplyr::select(-Normal_Demand_gpy, -Efficient_Demand_gpy, -Inefficient_Demand_gpy, -Comment)
# Round to whole numbers
demand_afy$Normal_Demand_afy = round(demand_afy$Normal_Demand_afy, digits = 0)
demand_afy$Efficient_Demand_afy = round(demand_afy$Efficient_Demand_afy, digits = 0)
demand_afy$Inefficient_Demand_afy = round(demand_afy$Inefficient_Demand_afy, digits = 0)


# 6) Filter 'demand_afy' to 2020, 2030, 2040 and 2050 and compare normal demand to Table 6 in report
demand_2020 = demand_afy %>%
  filter(Year == 2020)
demand_2030 = demand_afy %>%
  filter(Year == 2030)
demand_2040 = demand_afy %>%
  filter(Year == 2040)
demand_2050 = demand_afy %>%
  filter(Year == 2050)
demand_compare = full_join(demand_2020, demand_2030)
demand_compare = full_join(demand_compare, demand_2040)
demand_compare = full_join(demand_compare, demand_2050)
# Summarize demand by provider and year (providers currently split by county)
demand_compare2 = demand_compare %>%
  group_by(WaterProvider, Year) %>%
  summarize(Normal_Demand_afy = sum(Normal_Demand_afy)) %>%
# Spread "Year" column into multiple columns to make comparisons easier
  spread(Year, Normal_Demand_afy)
demand_compare2 = as.data.frame(demand_compare2)


# 7) Summarize demand by county and compare to Table 5 in report
demand_compare3 = demand_compare %>%
  group_by(County, Year) %>%
  summarize(Normal_Demand_afy = sum(Normal_Demand_afy)) %>%
  # Spread "Year" column into multiple columns to make comparisons easier
  spread(Year, Normal_Demand_afy)
demand_compare3 = as.data.frame(demand_compare3)


# 8) Export data
# Export 'demand_afy' to ...TODO.  Possibly create 3 separate files for the 3 efficiencies.
