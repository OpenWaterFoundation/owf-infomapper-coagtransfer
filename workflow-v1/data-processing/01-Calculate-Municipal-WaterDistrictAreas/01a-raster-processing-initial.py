# Initial processing of raster data provided by WestWater Research.
# 5 raster files were provided that are rasterized layers representing counties, municipal boundaries, water district 
# boundaries, irrigated lands and developed/developable lands.

# The steps are to reproject each layer to NAD83 UTM Zone 13N so that units are in meters (currently 4 of the 5 layers 
# are in WGS84 and one is in NAD83) and then build a virtual raster where each layer is a band within the same raster.  
# The multi-band raster will then be read into R where the data from each band will be extracted as a single CSV file so 
# that calculations on the data can be performed.  For example, the area of each municipality that is developed land, 
# potentially developable land, and not developable land will be calculated.

# This step is necessary to understand at which point (area) do certain municipalities reach municipal build-out and 
# to be able to estimate the proportion of water district population that is in unincorporated areas.

# Assumes that a new project has been created by opening up QGIS
# Testing with QGIS version 3.4

# Load in the required libraries
from qgis.core import *
import qgis.utils
import processing
import gdal
import os
from osgeo import ogr

# Create an object titled 'project' that is the project instance
project = QgsProject.instance()

# 1) Read in data.  All data were in a single geodatabase and extracted as GeoTIFFs in ArcGIS Pro.
munis = QgsRasterLayer("E:/Data/data-orig/Rasters/Municipality.tif", "munis")
project.addMapLayer(munis)  
# Then to check if the layer is valid:
if not munis.isValid():
  print("Layer failed to load!")

districts = QgsRasterLayer("E:/Data/data-orig/Rasters/WaterProviders.tif", "districts")
project.addMapLayer(districts)  
# Then to check if the layer is valid:
if not districts.isValid():
  print("Layer failed to load!") 
  
counties = QgsRasterLayer("E:/Data/data-orig/Rasters/County.tif", "counties")
project.addMapLayer(counties)  
# Then to check if the layer is valid:
if not counties.isValid():
  print("Layer failed to load!")   
  
irrig = QgsRasterLayer("E:/Data/data-orig/Rasters/Irrigation.tif", "irrig")
project.addMapLayer(irrig)  
# Then to check if the layer is valid:
if not irrig.isValid():
  print("Layer failed to load!")   

develop = QgsRasterLayer("E:/Data/data-orig/Rasters/LandDevelopment.tif", "develop")
project.addMapLayer(develop)  
# Then to check if the layer is valid:
if not develop.isValid():
  print("Layer failed to load!")  
  
  
# 2) Reproject each raster and add back in
parameters = {'INPUT':munis,
			  'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			  'RESAMPLING':0,
			  'NODATA':-9999,
			  'OUTPUT':'E:/Data/data-orig/Rasters/Municipality_NAD83.tif'}
processing.run("gdal:warpreproject", parameters)
munis2 = QgsRasterLayer("E:/Data/data-orig/Rasters/Municipality_NAD83.tif", "munis2")
project.addMapLayer(munis2)  

parameters2 = {'INPUT':districts,
			  'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			  'RESAMPLING':0,
			  'NODATA':-9999,
			  'OUTPUT':'E:/Data/data-orig/Rasters/WaterProviders_NAD83.tif'}
processing.run("gdal:warpreproject", parameters2)
districts2 = QgsRasterLayer("E:/Data/data-orig/Rasters/WaterProviders_NAD83.tif", "districts2")
project.addMapLayer(districts2) 

parameters3 = {'INPUT':counties,
			  'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			  'RESAMPLING':0,
			  'NODATA':-9999,
			  'OUTPUT':'E:/Data/data-orig/Rasters/County_NAD83.tif'}
processing.run("gdal:warpreproject", parameters3)
counties2 = QgsRasterLayer("E:/Data/data-orig/Rasters/County_NAD83.tif", "counties2")
project.addMapLayer(counties2) 

parameters4 = {'INPUT':irrig,
			  'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			  'RESAMPLING':0,
			  'NODATA':-9999,
			  'OUTPUT':'E:/Data/data-orig/Rasters/Irrigation_NAD83.tif'}
processing.run("gdal:warpreproject", parameters4)
irrig2 = QgsRasterLayer("E:/Data/data-orig/Rasters/Irrigation_NAD83.tif", "irrig2")
project.addMapLayer(irrig2) 

parameters5 = {'INPUT':develop,
			  'TARGET_CRS':QgsCoordinateReferenceSystem('EPSG:26913'),
			  'RESAMPLING':0,
			  'NODATA':-9999,
			  'OUTPUT':'E:/Data/data-orig/Rasters/LandDevelopment_NAD83.tif'}
processing.run("gdal:warpreproject", parameters5)
develop2 = QgsRasterLayer("E:/Data/data-orig/Rasters/LandDevelopment_NAD83.tif", "develop2")
project.addMapLayer(develop2)

# Remove original layers from project to avoid confusion
project.removeMapLayer(munis)
project.removeMapLayer(districts)
project.removeMapLayer(counties)
project.removeMapLayer(irrig)
project.removeMapLayer(develop)


# 3) Create virtual raster; save as a tif
parameters6 = {'INPUT': [munis2, districts2, counties2, irrig2, develop2],
                'RESOLUTION':0,
				'SEPARATE':True,
				'PROJ_DIFFERENCE':False,
				'ADD_ALPHA':False,
				'ASSIGN_CRS':None,
				'RESAMPLING':0,
				'OUTPUT':'E:/Data/data-processing/01-Calculate-Municipal-WaterDistrictAreas/Virtual_Raster.vrt'}  
processing.run("gdal:buildvirtualraster", parameters6)
virtual = QgsRasterLayer("E:/Data/data-processing/01-Calculate-Municipal-WaterDistrictAreas/Virtual_Raster.vrt", "virtual")
project.addMapLayer(virtual)
# Then must manually export as a tif (Virtual_Raster.tif).  Tried doing this in the script and appears to work but resulting 
# raster has no data.
