# Calculate supply from irrigated lands that are transferred from agricultural use to municipal use

# Background: in WWR's analysis, it was assumed that land development onto currently irrigated lands would provide 
# additional water supplies to the associated municipality or water district (p. 21).  The additional water supply 
# was estimated based on the presently irrigated acreage and an average net irrigation requirement (NIR) for the three
# crops with the greatest acreage in a given county.

# This script counts the number of 'irrigated' cells per municipality/water district and county combo for each year 
# and converts the cell count to acres of land.  Acres are then multiplied by the average NIR for the county the 
# municipality/water district is in to get the amount of water used, which is then converted to acre-feet 
# per year.

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\Calculate-Supply\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "supply-from-irrigated-lands.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

library(dplyr) # For data manipulation and organization
library(rgdal)  # Used for reading in raster files
library(raster) # Used to create, manipulate, and export raster data

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# Need to perform steps 1-8 for each of the 3 density options, so use a for loop.
supply_list = list()
for (density in c("Low", "Medium", "High")) {

# 1)  Read in data
filename = paste0("..\\11-Map-LandDevelopment\\",density, "_Density_Muni.tif")

# Create RasterLayers from each band
munis = raster(filename, band=1)
# Check the properties; should be a RasterLayer
munis

irrig = raster(filename, band=4)
# Check the properties; should be a RasterLayer
irrig

develop = raster(filename, band=5)
# Check the properties; should be a RasterLayer
develop

counties = raster(filename, band=6)
# Check the properties; should be a RasterLayer
counties

years = raster(filename, band=7)
# Check the properties; should be a RasterLayer
years
# Plot data to make sure it looks right
plot(years, main = "Growth by Years")


# 2)  Create a RasterStack from all 5 rasters
all = stack(munis, irrig, develop, counties, years)


# 3) Extract the data; number of values equals the number of cells
all2 = raster::extract(all, 1:ncell(all))
# Convert to a dataframe in order to calculate summary statistics
all2 = as.data.frame(all2)
head(all2)


# 4)  Edit data to have specific column names and replace numbers with names
# Rename column names
all3 = all2 %>%
  rename(Municipality = paste0(density,"_Density_Muni.1"), IrrigatedLand = paste0(density,"_Density_Muni.2"), 
         Developed = paste0(density,"_Density_Muni.3"), County = paste0(density,"_Density_Muni.4"), 
         Year = paste0(density,"_Density_Muni.5")) %>%
  # Filter out NAs
  filter(Municipality != 'NA') %>%
  # Sort data
  arrange(Municipality, County, Year)


# 5) For each municipality/county/year combo, count the number of cells that have an IrrigatedLand value of 2 and 
# convert to square meters, then acres
counts = all3 %>%
  filter(IrrigatedLand == 2) %>%
  filter(Year != '2018') %>% # Get rid of current conditions
  group_by(Municipality, County, Year) %>%
  count(IrrigatedLand) %>%
  rename(IrrigatedCells = n) %>%
  dplyr::select(-IrrigatedLand) %>%
  mutate(Irrigated_Land_sqmeters = IrrigatedCells * 134.094 * 134.094) %>%
  mutate(Irrigated_Land_acres = Irrigated_Land_sqmeters * 0.000247105)


# 6) Read in average crop net irrigation requirements (NIRs).  Units are acre-inches/acre.
nir = read.csv("crop-net-irrigation-requirement.csv", header = TRUE)
head(nir)

# Calculate average NIR for each county
nir = nir %>%
  group_by(County) %>%
  summarize(Average_NIR_acre_inches = mean(NIR_acre_inches)) %>%
  # Convert to acre-feet/acre
  mutate(Average_NIR_acre_feet = Average_NIR_acre_inches / 12)


# 7) Change county numbers to county names in 'counts' to join with 'nir'
county_names = read.csv("..\\..\\data-orig\\Rasters\\County.csv", header = TRUE)
counts = left_join(counts, county_names, by = c("County" = "Value"))
# Join with 'nir'
supply = left_join(counts, nir, by = c("NAME" = "County"))
supply = as.data.frame(supply)
# Multiply "Irrigated_Land_acres" by "Average_NIR_acre_feet" to get acre-feet per year
supply = supply %>%
  mutate(Supply_AFY = Irrigated_Land_acres * Average_NIR_acre_feet) %>%
  # Delete unneeded columns
  dplyr::select(Municipality, NAME, Year, Irrigated_Land_acres, Average_NIR_acre_feet, Supply_AFY) %>%
  rename(County = NAME)


# 8) Change municipality numbers to municipality names
muni_names = read.csv("..\\..\\data-orig\\Rasters\\Municipality.csv", header = TRUE)
supply = left_join(supply, muni_names, by = c("Municipality" = "Value"))
supply = supply %>%
  dplyr::select(cityname, County, Year, Irrigated_Land_acres, Average_NIR_acre_feet, Supply_AFY) %>%
  rename(Municipality = cityname) %>%
  arrange(Municipality, County, Year)

# Add supply to list
supply_list[[density]] = supply
print(density) 

}


# 9) Create dataframes for each density option
low_muni = as.data.frame(supply_list[["Low"]])
medium_muni = as.data.frame(supply_list[["Medium"]])
high_muni = as.data.frame(supply_list[["High"]])


# 10) Add a "Density_Option" variable
low_muni$Density_Option = "Low"
medium_muni$Density_Option = "Medium"
high_muni$Density_Option = "High"



# DO THE SAME FOR WATER DISTRICTS
  


# 11) Summarize total supply for the period 2020-2050.
total_supply = supply %>%
  summarize(Total_Supply = sum(Supply_AFY))




