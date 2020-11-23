# Initial processing of raster data provided by WestWater Research.
# 5 raster files were provided that are rasterized layers representing counties, municipal boundaries, water district 
# boundaries, irrigated lands and developed/developable lands.

# Each raster was reprojected to NAD83 UTM Zone 13N so that units are in meters and then a virtual raster was built
# where each raster layer is a band within the same raster.  These steps were completed in the file 
# 'raster-initial-processing.py'.

# In this script, the data from each band is extracted as a single dataframe so 
# that calculations on the data can be performed.  For example, the area of each municipality that is developed land, 
# developable land, and not developable land is calculated.


# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\01-Calculate-Municipal-WaterDistrictAreas\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "raster-processing-initial.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr) # For data manipulation and organization
library(rgdal)  # Used for reading in raster files
library(raster) # Used to create, manipulate, and export raster data


# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1)  Read in data
filename = "Virtual_Raster.tif"

# Create RasterLayers from each band

munis = raster(filename, band=1)
# Check the properties; should be a RasterLayer
munis
# Plot data to make sure it looks right
plot(munis, main = "Municipalities")

districts = raster(filename, band=2)
# Check the properties; should be a RasterLayer
districts
# Plot data to make sure it looks right
plot(districts, main = "Water Providers")

counties = raster(filename, band=3)
# Check the properties; should be a RasterLayer
counties
# Plot data to make sure it looks right
plot(counties, main = "Counties")

irrig = raster(filename, band=4)
# Check the properties; should be a RasterLayer
irrig
# Plot data to make sure it looks right
plot(irrig, main = "Irrigated Lands")

develop = raster(filename, band=5)
# Check the properties; should be a RasterLayer
develop
# Plot data to make sure it looks right
plot(develop, main = "Land Development")


# 2)  Create a RasterStack from all 5 rasters
all = stack(munis, districts, counties, irrig, develop)


# 3) Extract the data; number of values equals the number of cells
all2 = raster::extract(all, 1:ncell(all))
# Convert to a dataframe in order to calculate summary statistics
all2 = as.data.frame(all2)
head(all2)


# 4)  Edit data to have specific column names and replace numbers with names
# Rename column names
all2 = all2 %>%
  rename(Municipality = Virtual_Raster.1, WaterProvider = Virtual_Raster.2, County = Virtual_Raster.3, 
         IrrigatedLand = Virtual_Raster.4, LandDevelopment = Virtual_Raster.5)
# Replace numbers in IrrigatedLand column
all2$IrrigatedLand = replace(all2$IrrigatedLand, all2$IrrigatedLand == "1", "Not Irrigated")
all2$IrrigatedLand = replace(all2$IrrigatedLand, all2$IrrigatedLand == "2", "Irrigated")
# Replace numbers in LandDevelopment column
all2$LandDevelopment = replace(all2$LandDevelopment, all2$LandDevelopment == "1", "Potentially Developable")
all2$LandDevelopment = replace(all2$LandDevelopment, all2$LandDevelopment == "2", "Developed")
all2$LandDevelopment = replace(all2$LandDevelopment, all2$LandDevelopment == "3", "Not Developable")


# 5) Summaries
# a.  Summarize area of each municipality, split by county as necessary
muni_area = all2 %>%
  filter(Municipality != 'NA') %>%
  filter(Municipality != 1) %>% # 1 is None
  count(Municipality, County) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(Muni_Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(Muni_Area_sqmiles = Muni_Area_sqmeters * 0.0000003861)
# Read in CSV of municipality names to replace numbers
muni_names = read.csv("..\\..\\data-orig\\Rasters\\Municipality.csv", header=TRUE)
# Join together
muni_area = left_join(muni_area, muni_names, by = c("Municipality" = "Value"))
# Read in CSV of county names to replace numbers
county_names = read.csv("..\\..\\data-orig\\Rasters\\County.csv", header=TRUE)
# Join together
muni_area = left_join(muni_area, county_names, by = c("County" = "Value"))

# Read in master list to filter municipalities
master = read.csv("..\\..\\data-downloads-and-preprocessing\\00-Create-WaterEntities-MasterList\\water-entities-master-list.csv", 
                  header = TRUE)
# Filter dataset
muni_area = semi_join(muni_area, master, by = c("cityname" = "WaterEntity"))
# Reorganize
muni_area = muni_area %>%
  dplyr::select(cityname, NAME, Count, Muni_Area_sqmeters, Muni_Area_sqmiles) %>% #Note need to use 'dplyr::' here
  rename(Municipality = cityname, County = NAME)
muni_area = as.data.frame(muni_area)

# b.  Summarize area of each county
county_area = all2 %>%
  filter(County != 'NA') %>%
  count(County) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(County_Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(County_Area_sqmiles = County_Area_sqmeters * 0.0000003861)
# Access CSV of county names to replace numbers
county_area = left_join(county_area, county_names, by = c("County" = "Value"))
# Reorganize
county_area = county_area %>%
  dplyr::select(NAME, Count, County_Area_sqmeters, County_Area_sqmiles) %>%
  rename(County = NAME) %>%
  arrange(County)
county_area = as.data.frame(county_area)

# c.  Summarize area of each water provider, split by county as necessary
district_area = all2 %>%
  filter(WaterProvider != 'NA') %>%
  filter(WaterProvider != 1) %>% # 1 is None
  count(WaterProvider, County) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(District_Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(District_Area_sqmiles = District_Area_sqmeters * 0.0000003861)
# Read in CSV of water provider names to replace numbers
district_names = read.csv("..\\..\\data-orig\\Rasters\\WaterProviders.csv", header=TRUE)
# Join together
district_area = left_join(district_area, district_names, by = c("WaterProvider" = "Value"))
# Replace county numbers with names
district_area = left_join(district_area, county_names, by = c("County" = "Value"))
# Sort by Water Provider
district_area = district_area %>%
  arrange(WaterProvider)

# Filter dataset to master list; note that the WaterProvider raster includes municipalities, not just water districts, 
# so the data need to be filtered to only the districts
master_district = master %>%
  filter(LocalGovtType != "Municipality")
district_area = semi_join(district_area, master_district, by = c("Name" = "WaterEntity"))
# Reorganize
district_area = district_area %>%
  dplyr::select(Name, NAME, Count, District_Area_sqmeters, District_Area_sqmiles) %>% #Note need to use 'dplyr::' here
  rename(WaterProvider = Name, County = NAME) %>%
  # Sum areas that have same water provider/county combo
  group_by(WaterProvider, County) %>%
  summarize(District_Area_sqmiles = sum(District_Area_sqmiles)) %>%
  arrange(WaterProvider)
district_area = as.data.frame(district_area)
# 2 districts, Left Hand Water District and Longs Peak Water District, have very small areas in Boulder County that 
# were cut off due to the nature of rasterizing the County spatial layer.  These list the County as NA. Delete these.
district_area = na.omit(district_area)

# d.  Calculate the area of overlap between water providers and municipalities of DEVELOPED land only
muni_district = all2 %>%
  filter(WaterProvider != 'NA') %>%
  filter(WaterProvider != 1) %>% # 1 is None
  filter(LandDevelopment == "Developed") %>%
  count(WaterProvider, Municipality, County) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(Overlap_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(Overlap_sqmiles = Overlap_sqmeters * 0.0000003861)
# Replace water provider numbers with names
muni_district = left_join(muni_district, district_names, by = c("WaterProvider" = "Value"))
# Replace municipality numbers with names
muni_district = left_join(muni_district, muni_names, by = c("Municipality" = "Value"))
# Replace county numbers with names
muni_district = left_join(muni_district, county_names, by = c("County" = "Value"))
# Reorganize
muni_district = muni_district %>%
  dplyr::select(Name, cityname, NAME, Overlap_sqmiles) %>% #Note need to use 'dplyr::' here
  rename(WaterProvider = Name, Municipality = cityname, County = NAME) %>%
  group_by(WaterProvider, Municipality, County) %>%
  summarize(Overlap_sqmiles = sum(Overlap_sqmiles)) %>%
  arrange(WaterProvider)

# Join dataset to muni_area to filter to needed combos only
muni_district = semi_join(muni_district, muni_area, by = c("Municipality" = "Municipality"), keep=TRUE)

# e.  Calculate proportion of overlap of water providers and municipalities of total area of each provider/muni, split
#     by county as necessary (DEVELOPED lands only)
# Join muni_district to district_area
proportions = left_join(muni_district, district_area, by = c("WaterProvider" = "WaterProvider", "County" = "County"))
# Calculate proportion
proportions = proportions %>%
  mutate(Proportion_of_District = Overlap_sqmiles / District_Area_sqmiles)
proportions = as.data.frame(proportions)
# Join muni_district to muni_area
proportions = left_join(proportions, muni_area, by = c("Municipality" = "Municipality", "County" = "County"))
# Calculate proportion
proportions = proportions %>%
  mutate(Proportion_of_Muni = Overlap_sqmiles / Muni_Area_sqmiles) %>%
  # Reorganize
  dplyr::select(-Count, -Muni_Area_sqmeters) %>%
  arrange(WaterProvider)
# Dataset still contains municipalities listed as water providers.  Filter these out based on the master_district list
proportions = semi_join(proportions, master_district, by = c("WaterProvider" = "WaterEntity"))

# f. Summarize the number of cells per municipality/land development combo; split municipalities by county 
#    as appropriate.
#    This step is necessary to understand at which point (area) do certain municipalities reach municipal build-out.
muni_develop = all2 %>%
  filter(Municipality != 'NA') %>%
  filter(Municipality != 1) %>% # 1 is None
  count(Municipality, County, LandDevelopment) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(Area_sqmiles = Area_sqmeters * 0.0000003861)
# Read in CSV of municipality names to replace numbers
muni_names = read.csv("..\\..\\data-orig\\Rasters\\Municipality.csv", header=TRUE)
# Join together
muni_develop = left_join(muni_develop, muni_names, by = c("Municipality" = "Value"))
# Read in CSV of county names to replace numbers
county_names = read.csv("..\\..\\data-orig\\Rasters\\County.csv", header=TRUE)
# Join together
muni_develop = left_join(muni_develop, county_names, by = c("County" = "Value"))

# Filter dataset
muni_develop = semi_join(muni_develop, master, by = c("cityname" = "WaterEntity"))
# Reorganize
muni_develop = muni_develop %>%
  dplyr::select(cityname, NAME, LandDevelopment, Count, Area_sqmeters, Area_sqmiles) %>% #Note need to use 'dplyr::' here
  rename(Municipality = cityname, County = NAME)

# Make sure right variables are numeric
muni_develop$Count = as.numeric(muni_develop$Count)
muni_develop$Area_sqmeters = as.numeric(muni_develop$Area_sqmeters)
muni_develop$Area_sqmiles = as.numeric(muni_develop$Area_sqmiles)

# g. Summmarize the amount of developed land in unincorporated county areas.  Note that this includes areas WITHIN
#    water district boundaries
# There is currently a work-around for several census-designated places (CDPs).  They should not be included as 
# municipalities because their populations are not provided in DOLA data (is part of unincorporated county pop).
# Pueblo West CDP (153) for Pueblo West MD; Altona (6), Niwot (133), Gunbarrel (88) and Leyner (112) CDPs for 
# Left Hand Water District; Derby CDP (53) for South Adams County WSD; Fairmount CDP (65) for North Table Mtn WSD;
# West Pleasant View (192), Applewood (7), and East Pleasant View (55) CDPs for Consolidated Mutual Water Company;
# Louviers CDP (121) for Louviers WSD; Roxborough Park CDP (160) for Roxborough WSD; Dove Valley (54) and 
# Inverness (95) CDPs for Arapahoe County Water and Wastewater Authority; Inverness CDP (95) for Inverness WSD; 
# The Pinery CDP (178) for Denver Southeast Suburban WSD; Perry Park CDP (147) for Perry Park WSD; Woodmoor CDP (198) 
# for Woodmoor WSD No. 1; Gleneagle CDP (82) for Donala WSD; Cimarron Hills CDP (40) for Cherokee MD; Security-
# Widefield CDP (163) for Security WSD; Salt Creek (162), Blende (19) and Vineland (186) CDPs for St. Charles Mesa WD;
# Highlands Ranch CDP (90) for Centennial WSD.
unincorp = all2 %>%
  filter(County != 'NA') %>%
  filter(Municipality %in% c(1, 153, 6, 133, 88, 112, 53, 65, 192, 7, 55, 121, 160, 54, 95, 178, 147, 198, 82, 40, 
                             163, 162, 19, 186, 90)) %>% # 1 is None, so outside of municipal boundaries, plus CDPs 
                                                        # listed above
  filter(WaterProvider != 'NA') %>% 
  count(County, LandDevelopment) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(Area_sqmiles = Area_sqmeters * 0.0000003861)
# Join together with county names
unincorp = left_join(unincorp, county_names, by = c("County" = "Value"))
# Get rid of NAs
unincorp = na.omit(unincorp)
unincorp = as.data.frame(unincorp)
# Filter out counties that are not needed and rename county column
unincorp = unincorp %>%
  filter(NAME %in% c("Douglas", "Jefferson", "Boulder", "Broomfield", "Larimer", "El Paso", "Elbert", "Pueblo", 
                     "Arapahoe", "Denver", "Adams", "Weld")) %>%
  dplyr::select(-County) %>%
  rename("County" = "NAME") %>%
  arrange(County, LandDevelopment) %>%
  # Create a municipality 'name'
  mutate(Municipality = paste(County, "County Unincorporated Area"))

# h. Summarize the number of cells per water district/land development combo; split by county as appropriate.
# This focuses on the portion of the water district NOT within a municipality's boundaries.
# There is currently a work-around for several census-designated places (CDPs).  See description in g. above.
district_develop = all2 %>%
  filter(WaterProvider != 'NA') %>%
  filter(WaterProvider != 1) %>% # 1 is None
  filter(Municipality %in% c(1, 153, 6, 133, 88, 112, 53, 65, 192, 7, 55, 121, 160, 54, 95, 178, 147, 198, 82, 40, 
                             163, 162, 19, 186, 90)) %>% # 1 is None, so outside of municipal boundaries, plus CDPs 
                                                         # listed above
  count(WaterProvider, County, LandDevelopment) %>%
  rename(Count = n) %>%
  # Each cell (pixel) is 134.094 meters by 134.094 meters, so multiply Count accordingly to get square meters
  mutate(Area_sqmeters = Count * 134.094 * 134.094) %>%
  # Then get square miles
  mutate(Area_sqmiles = Area_sqmeters * 0.0000003861)
# Replace water provider numbers with names
district_develop = left_join(district_develop, district_names, by = c("WaterProvider" = "Value"))
# Replace county numbers with names
district_develop = left_join(district_develop, county_names, by = c("County" = "Value"))
# Reorganize
district_develop = district_develop %>%
  dplyr::select(Name, NAME, LandDevelopment, Count, Area_sqmeters, Area_sqmiles) %>%
  rename(County = NAME, WaterProvider = Name) %>%
  arrange(WaterProvider, County)
# Filter to master list
district_develop = semi_join(district_develop, master_district, by = c("WaterProvider" = "WaterEntity"))
district_develop = as.data.frame(district_develop)


# 6) Export data
# Export muni_area to folder 02-Calculate-PopulationDensity
write.csv(muni_area, "..\\02-Calculate-PopulationDensity\\municipal-area.csv", row.names = FALSE)
# Export county_area to folder 02-Calculate-PopulationDensity
write.csv(county_area, "..\\02-Calculate-PopulationDensity\\county-area.csv", row.names = FALSE)
# Export district_area to folder 05-Calculate-WaterDistrictPopulation-withinMunis
write.csv(district_area, "..\\05-Calculate-WaterDistrictPopulation-withinMunis\\waterdistrict-area.csv", row.names = FALSE)
# Export proportions to folder 05-Calculate-WaterDistrictPopulation-withinMunis
write.csv(proportions, "..\\05-Calculate-WaterDistrictPopulation-withinMunis\\waterdistrict-proportions.csv", row.names = FALSE)
# Export muni_develop to folder 02-Calculate-PopulationDensity
write.csv(muni_develop, "..\\02-Calculate-PopulationDensity\\municipal-land-development.csv", row.names = FALSE)
# Export unincorp to folder 06-Calculate-WaterDistrictPopulation-withinUnincorporated
write.csv(unincorp, "..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\unincorporated-land-development.csv", row.names = FALSE)
# Export district_develop to folder 06-Calculate-WaterDistrictPopulation-withinUnincorporated
write.csv(district_develop, "..\\06-Calculate-WaterDistrictPopulation-withinUnincorporated\\waterdistrict-land-development.csv", row.names = FALSE)
