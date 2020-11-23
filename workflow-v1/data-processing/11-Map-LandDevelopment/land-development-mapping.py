# ** THIS FILE IS CURRENTLY NOT BEING USED.  KMS ATTEMPTED TO DO THE MAPPING IN PYQGIS BUT COULD NOT FIGURE OUT ALL OF THE
# NECESSARY STEPS.  THE ACTUAL MAPPING IS DONE IN R SCRIPTS IN THIS SAME FOLDER.  THIS FILE CONTAINS THE INITIAL WORK THAT 
# WAS DONE FOR REFERENCE, BUT IT SHOULD BE UNDERSTOOD THAT THE PROCESS IS INCOMPLETE. **

# This script estimates where municipal and water district land growth will occur, particularly as it pertains to irrigated 
# vs. non-irrigated lands.

# The starting layers are 5 raster files that were provided by WestWater Research that are rasterized layers representing 
# counties, municipal boundaries, water district boundaries, irrigated lands and developed/developable lands.  These layers
# were converted to NAD83 UTM Zone 13N so that units of measurement are in meters.

# The overall objective is to spatially identify where new population will be located along the Front Range.  The 
# mapping analysis is a necessary step to estimate growth onto irrigated and non-irrigated lands.  The future land development 
# specific to each municipality was mapped using best judgment and the following assumptions:
# Municipalities will first use undeveloped lands and irrigated lands within their existing built out areas to support new growth, 
# before expanding the build-out footprint.
# Unincorporated areas that currently support a significant population were not assumed to support any new growth.  
# Where possible, municipal growth onto enclaves (unincorporated areas which are completely surrounded by municipal boundaries) 
# were prioritized before expanding the municipal build out footprint.
# Municipal growth outside of the existing developed footprint occurs in a radial fashion, with new land development assigned 
# directly next to current built areas where possible.

# The specific objectives are to take the amount of annual new growth in square miles for each water provider and convert the amount 
# to a count of cells/pixels in the raster.  The cells need to belong to the Land Development category of "Potentially Developable". 
# Those cells will then be reclassified as "Developed", creating a new raster of land development.  This new raster will then be used 
# to estimate land growth for the following year.  The process will be repeated to the year 2050. 

# Assumes that a new project has been created by opening up QGIS
# Testing with QGIS version 3.4;  TO USE GRASS YOU MUST OPEN THE QGIS VERSION 'QGIS DESKTOP 3.4 WITH GRASS 7.6' OR WHATEVER THE LATEST 
# VERSIONS ARE.

# Load in the required libraries
from qgis.core import *
import qgis.utils
import processing
import gdal
import os
from osgeo import ogr

# Create an object titled 'project' that is the project instance
project = QgsProject.instance()

# Create an object that is the working directory, which simplifies saving output files
mydir = "E:/Data/data-processing/11-Map-LandDevelopment/"

# 1) Read in data 
# a. Read in reprojected raster layers.
munis = QgsRasterLayer("E:/Data/data-orig/Rasters/Municipality_NAD83.tif", "munis")
project.addMapLayer(munis)  
# Then to check if the layer is valid:
if not munis.isValid():
  print("Layer failed to load!")

districts = QgsRasterLayer("E:/Data/data-orig/Rasters/WaterProviders_NAD83.tif", "districts")
project.addMapLayer(districts)  
# Then to check if the layer is valid:
if not districts.isValid():
  print("Layer failed to load!")   
  
irrig = QgsRasterLayer("E:/Data/data-orig/Rasters/Irrigation_NAD83.tif", "irrigated-lands")
project.addMapLayer(irrig)  
# Then to check if the layer is valid:
if not irrig.isValid():
  print("Layer failed to load!")   

develop = QgsRasterLayer("E:/Data/data-orig/Rasters/LandDevelopment_NAD83.tif", "land-development")
project.addMapLayer(develop)  
# Then to check if the layer is valid:
if not develop.isValid():
  print("Layer failed to load!")  

# b. Read in csv of cells to reclassify
uri1 = "file:///E:/Data/data-processing/11-Map-LandDevelopment/municipal-cells-to-reclassify.csv?delimiter=%s" % (",")
reclass = QgsVectorLayer(uri1, 'municipal-cells-to-reclassify','delimitedtext')
project.instance().addMapLayer(reclass)  
  

# 2)  Take the LandDevelopment raster ('develop') and create two new rasters, one of "Developed" land
# and one of "Potentially Developable" land.  Uses the Raster Calculator from gdal.
# a.
parameters1 = {'INPUT_A':'E:/Data/data-orig/Rasters/LandDevelopment_NAD83.tif',
               'BAND_A':1,  # only has 1 band so use '1'
			   'INPUT_B':None, # can enter multiple rasters, but not doing this here
			   'BAND_B':-1,
			   'INPUT_C':None,
			   'BAND_C':-1,
			   'INPUT_D':None,
			   'BAND_D':-1,
			   'INPUT_E':None,
			   'BAND_E':-1,
			   'INPUT_F':None,
			   'BAND_F':-1,
			   'FORMULA':'A == 2', # only including values of 2, which represent Developed land
			   'NO_DATA':None,
			   'RTYPE':5,
			   'OPTIONS':'',
			   'OUTPUT':mydir + "Developed.tif"}
processing.run("gdal:rastercalculator", parameters1)
developed = QgsRasterLayer(mydir + "Developed.tif", "developed-lands") 
project.addMapLayer(developed)

# b.
parameters2 = {'INPUT_A':'E:/Data/data-orig/Rasters/LandDevelopment_NAD83.tif',
               'BAND_A':1,  # only has 1 band so use '1'
			   'INPUT_B':None, # can enter multiple rasters, but not doing this here
			   'BAND_B':-1,
			   'INPUT_C':None,
			   'BAND_C':-1,
			   'INPUT_D':None,
			   'BAND_D':-1,
			   'INPUT_E':None,
			   'BAND_E':-1,
			   'INPUT_F':None,
			   'BAND_F':-1,
			   'FORMULA':'A == 1', # only including values of 1, which represent Potentially Developable land
			   'NO_DATA':None,
			   'RTYPE':5,
			   'OPTIONS':'',
			   'OUTPUT':mydir + 'PotentiallyDevelopable.tif'}

processing.run("gdal:rastercalculator", parameters2)
potential = QgsRasterLayer(mydir + "PotentiallyDevelopable.tif", "potentially-developable") 
project.addMapLayer(potential)
# See example: https://anitagraser.com/pyqgis-101-introduction-to-qgis-python-programming-for-non-programmers/pyqgis-101-running-processing-tools/
# for another way to do this.  KMS cannot get this to work.  Would be nice to do this way so that outputs are in memory, but can also delete the 
# files once the processes are complete.


# The remaining steps need to be done for each municipality and water district, so will require a for loop.
# CURRENTLY TESTING WITH ONLY ONE MUNICIPALITY TO GET THE PROCESS FIGURED OUT.
# Create a list of water providers from the 'reclass' layer that can then be used in a for loop
providers = [i.attributes() for i in reclass.getFeatures()]
providers = [i[0] for i in providers]
providers = [str(r) for r in providers]
providers = set(providers) # Keeps only unique values
providers = sorted(providers) # Put back in alphabetical order


# 3) Create masks for each municipality to limit analysis to within municipal boundaries.  Uses the r.mask.rast tool from GRASS
# Three masks should be created: one on the "Developed" layer created in step 2a; one for irrigated lands; and one for potentially developable lands. This 
# will keep the size of the virtual raster smaller.
# The '70' for 'maskcats' represents Fort Collins
parameters3a = {'raster':'E:/Data/data-orig/Rasters/Municipality_NAD83.tif',  # The layer to be masked (each municipality will have its own mask)
               'input':mydir + 'Developed.tif', # The layer that will contain the data (developed lands within the municipality)
			   'maskcats':'70',
			   '-i':False,
			   'output':mydir + 'Mask-Developed1.tif',
			   'GRASS_REGION_PARAMETER':None,
			   'GRASS_REGION_CELLSIZE_PARAMETER':0,
			   'GRASS_RASTER_FORMAT_OPT':'',
			   'GRASS_RASTER_FORMAT_META':''}
processing.run("grass7:r.mask.rast", parameters3a)
# Don't add yet; will add when reprojected

parameters3b = {'raster':'E:/Data/data-orig/Rasters/Municipality_NAD83.tif',  # The layer to be masked (each municipality will have its own mask)
               'input':mydir + 'PotentiallyDevelopable.tif', # The layer that will contain the data (potentially developable lands within the municipality)
			   'maskcats':'70',
			   '-i':False,
			   'output':mydir + 'Mask-Potential1.tif',
			   'GRASS_REGION_PARAMETER':None,
			   'GRASS_REGION_CELLSIZE_PARAMETER':0,
			   'GRASS_RASTER_FORMAT_OPT':'',
			   'GRASS_RASTER_FORMAT_META':''}
processing.run("grass7:r.mask.rast", parameters3b)
# Don't add yet; will add when reprojected

parameters3c = {'raster':'E:/Data/data-orig/Rasters/Municipality_NAD83.tif',  # The layer to be masked (each municipality will have its own mask)
               'input':'E:/Data/data-orig/Rasters/Irrigation_NAD83.tif', # The layer that will contain the data (irrigated lands within the municipality)
			   'maskcats':'70',
			   '-i':False,
			   'output':mydir + 'Mask-Irrigated1.tif',
			   'GRASS_REGION_PARAMETER':None,
			   'GRASS_REGION_CELLSIZE_PARAMETER':0,
			   'GRASS_RASTER_FORMAT_OPT':'',
			   'GRASS_RASTER_FORMAT_META':''}
processing.run("grass7:r.mask.rast", parameters3c)
# Don't add yet; will add when reprojected


# 4) Calculate distance of cells from the Developed layer created in step 2a using the mask created in 
# step 3.  Uses the r.grow.distance tool from GRASS, which generates a raster layer of distance to features in the 
# input (developed lands) layer.
parameters4 = {'input':mydir + 'Mask-Developed1.tif',
               'metric':0, # 0 indicates Euclidean
			   '-m':False,
			   '-':False,
			   'distance':mydir + 'Distance.tif',
			   'value':mydir + 'Value.tif', # creates a separate tif that is the value of the nearest cell; is not needed for our purposes so will delete
			   'GRASS_REGION_PARAMETER':None,
			   'GRASS_REGION_CELLSIZE_PARAMETER':0,
			   'GRASS_RASTER_FORMAT_OPT':'',
			   'GRASS_RASTER_FORMAT_META':''}
processing.run("grass7:r.grow.distance", parameters4)
distance1 = QgsRasterLayer(mydir + "Distance.tif", "distance1") 
project.addMapLayer(distance1)


# 5) Reproject distance layer and masks into NAD83 UTM Zone 13N (EPSG:26913).  For some reason the mask layers are not 
# in this projection and this extends to the distance layer as well
parameters5a = {'INPUT':mydir + 'Distance.tif',
               'SOURCE_CRS':QgsCoordinateReferenceSystem('EPSG:2957'),
			   'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			   'RESAMPLING':0,
			   'NODATA':None,
			   'TARGET_RESOLUTION':None,
			   'OPTIONS':'',
			   'DATA_TYPE':0,
			   'TARGET_EXTENT':None,
			   'TARGET_EXTENT_CRS':None,
			   'MULTITHREADING':False,
			   'EXTRA':'',
			   'OUTPUT':mydir + 'Distance_NAD83.tif'}
processing.run("gdal:warpreproject", parameters5a)
distance = QgsRasterLayer(mydir + "Distance_NAD83.tif", "distance-from-developed-lands") 
project.addMapLayer(distance)
# Remove distance1 layer
project.removeMapLayer(distance1)

parameters5b = {'INPUT':mydir + 'Mask-Developed1.tif',
               'SOURCE_CRS':QgsCoordinateReferenceSystem('EPSG:2957'),
			   'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			   'RESAMPLING':0,
			   'NODATA':None,
			   'TARGET_RESOLUTION':None,
			   'OPTIONS':'',
			   'DATA_TYPE':0,
			   'TARGET_EXTENT':None,
			   'TARGET_EXTENT_CRS':None,
			   'MULTITHREADING':False,
			   'EXTRA':'',
			   'OUTPUT':mydir + 'Mask-Developed.tif'}
processing.run("gdal:warpreproject", parameters5b)
developed_mask = QgsRasterLayer(mydir + "Mask-Developed.tif", "developed-mask") 
project.addMapLayer(developed_mask)

parameters5c = {'INPUT':mydir + 'Mask-Potential1.tif',
               'SOURCE_CRS':QgsCoordinateReferenceSystem('EPSG:2957'),
			   'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			   'RESAMPLING':0,
			   'NODATA':None,
			   'TARGET_RESOLUTION':None,
			   'OPTIONS':'',
			   'DATA_TYPE':0,
			   'TARGET_EXTENT':None,
			   'TARGET_EXTENT_CRS':None,
			   'MULTITHREADING':False,
			   'EXTRA':'',
			   'OUTPUT':mydir + 'Mask-Potential.tif'}
processing.run("gdal:warpreproject", parameters5c)
potential_mask = QgsRasterLayer(mydir + "Mask-Potential.tif", "potential-mask") 
project.addMapLayer(potential_mask)

parameters5d = {'INPUT':mydir + 'Mask-Irrigated1.tif',
               'SOURCE_CRS':QgsCoordinateReferenceSystem('EPSG:2957'),
			   'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			   'RESAMPLING':0,
			   'NODATA':None,
			   'TARGET_RESOLUTION':None,
			   'OPTIONS':'',
			   'DATA_TYPE':0,
			   'TARGET_EXTENT':None,
			   'TARGET_EXTENT_CRS':None,
			   'MULTITHREADING':False,
			   'EXTRA':'',
			   'OUTPUT':mydir + 'Mask-Irrigated.tif'}
processing.run("gdal:warpreproject", parameters5d)
irrigated_mask = QgsRasterLayer(mydir + "Mask-Irrigated.tif", "irrigated-mask") 
project.addMapLayer(irrigated_mask)


# 6) Create a virtual raster of the 'distance-from-developed-lands', 'potential-mask', 'irrigated-mask', and 'developed-mask' layers; export as a tif
parameters6 = {'INPUT': [distance, potential_mask, irrigated_mask, developed_mask],
                'RESOLUTION':0,
				'SEPARATE':True,
				'PROJ_DIFFERENCE':False,
				'ADD_ALPHA':False,
				'ASSIGN_CRS':None,
				'RESAMPLING':0,
				'OUTPUT':mydir + 'Land_Growth.tif'}  
processing.run("gdal:buildvirtualraster", parameters6)
virtual = QgsRasterLayer(mydir + "Land_Growth.tif", "land-growth")
project.addMapLayer(virtual)


# The remaining steps are to take the cells that are potentially developable (value = 1), have the shortest distance (but greater than 0) from
# developed lands, and are irrigated (irrigated (value = 2) prioritized first, then non-irrigated (value = 1)) and reclassify (convert) them 
# from Potentially Developable to Developed.  The number of cells to reclassify for each year can be found in the file 
# 'municiapl-cells-to-reclassify.csv' and 'district-cells-to-reclassify.csv' ('reclass' layer that was added in 1b).  Will reclassify 'developed-mask' 
# from 0 to 1 for the number of cells specified.  Will reclassify 'potential-mask' from 1 to 0 for the number of cells specified.
# The 'developed-mask' layer needs to be exported as a tif and represents the developed area for that water provider for that specific year, which 
# can then be used in visualizations.  It also needs to be saved to be read in for the next year's growth.
# The 'potential-mask' layer needs to be saved so that it can be read in for the next year's growth.

# Seems like a vector of cells to reclassify each year is needed, as well as a vector of the years?  Then use a second for loop to 
# loop through years to 2050.
# Create list of years
years = [i.attributes() for i in reclass.getFeatures()]
years = [i[2] for i in years]
# Create list of cells to reclassify 
counts = [i.attributes() for i in reclass.getFeatures()]
counts = [i[8] for i in counts]
	
# More processing ...


# Remove intermediate/unneeded raster files to keep folder simple.
os.remove(mydir + 'Value.tif')
os.remove(mydir + 'Mask-Developed1.tif')
os.remove(mydir + 'Mask-Developed1.tfw')
os.remove(mydir + 'Mask-Potential1.tif')
os.remove(mydir + 'Mask-Potential1.tfw')
os.remove(mydir + 'Mask-Irrigated1.tif')
os.remove(mydir + 'Mask-Irrigated1.tfw')
os.remove(mydir + 'Mask-Irrigated1.tif.aux.xml')

# Then end the loop here




