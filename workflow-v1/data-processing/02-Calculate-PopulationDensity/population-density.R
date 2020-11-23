# Calculation of municipal population density

# Calculations use the rasterized municipal boundaries spatial data layer, which has incorporated all annexations 
# through 2018.
# Calculations use the forecasted municipal population data, which were calculated as proportions of county data.

# Note that unincorporated county area population densities are not calculated at this point, because much of the 
# population is actually within a water district, which will be figured out later.  Figuring population densities 
# for unincorporated areas at this stage creates very large densities because it appears as though you have a lot 
# of population within a small developed area, when actually that population is most likely within a water district.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\02-Calculate-PopulationDensity\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "population-density.R"
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
# a) Municipal area data were calculated in folder '01-Calculate-Municipal-WaterDistrictAreas' in the script 
#    'raster-processing-initial.R'.  The script specifically calculates separate areas for those municipalities that 
#    are in multiple counties.  Municipal boundaries were overlayed with the LandDevelopment layer to summarize the 
#    amount of land within each municipality that is already developed, not developable, or potentially developable. 
#    To get density estimates, will use the "Developed" category of land development to get density estimates for 2018.

muni_area = read.csv("municipal-land-development.csv", header = TRUE)
head(muni_area)

# b) Municipal forecasted population data were calculated in folder '00-Calculate-PopulationProjections' in the script 
#    'municipal-population-proportions.R'
pop = read.csv("..\\00-Calculate-PopulationProjections\\municipal-population-forecast.csv", header = TRUE)
head(pop)

# Glendale is entirely within Denver County, yet DOLA lists it as being in Arapahoe County.  After searching it 
# appears that Glendale is an exclave of Arapahoe County, so should put there.
muni_area2 = muni_area %>%
  filter(Municipality != 'Glendale')
glendale = muni_area %>%
  filter(Municipality == 'Glendale')
glendale$County = replace(glendale$County, glendale$County == "Denver", "Arapahoe")
glendale = glendale %>%
  group_by(Municipality, County, LandDevelopment) %>%
  summarize(Count = sum(Count), Area_sqmeters = sum(Area_sqmeters), Area_sqmiles = 
              sum(Area_sqmiles))
muni_area = full_join(muni_area2, glendale)
muni_area = muni_area %>%
  arrange(Municipality)


# 2) Filter population data to 2018 only
pop2018 = pop %>%
  filter(Year == 2018) %>% # Will calculate density from 2018 data
  arrange(MunicipalityName)

# Make sure total population is numeric
pop2018$Municipal_Population = as.numeric(pop2018$Municipal_Population)


# 3) Filter muni area data to land development category of "Developed" only
area2018 = muni_area %>%
  filter(LandDevelopment == "Developed") %>%
  dplyr::select(Municipality, County, Area_sqmiles)


# 4) Join 'area2018' to 'pop2018' by "MunicipalityName" and "Municipality"
density = left_join(pop2018, area2018, by = c("MunicipalityName" = "Municipality", "County" = "County"))


# 5) Calculate population density of municipalities
density = density %>%
  dplyr::select(MunicipalityName, County, Municipal_Population, Area_sqmiles) %>%
  mutate(Density = Municipal_Population / Area_sqmiles) %>%
  rename(Area_2018 = Area_sqmiles) %>%
  rename(Population_2018 = Municipal_Population)
density = as.data.frame(density)
# Remove NAs since these are munis/counties that aren't being analyzed
density = na.omit(density)


# 6) Export dataset of population density to folder 03-Calculate-LandAreaGrowth
write.csv(density, "..\\03-Calculate-LandAreaGrowth\\population-density.csv", row.names = FALSE)


# **Maybe recreate the graphs of density vs. population on pg. 16**
ggplot(density, aes(x = Population_2018, y = Density, color = County)) +
  geom_point()
  
  
  
