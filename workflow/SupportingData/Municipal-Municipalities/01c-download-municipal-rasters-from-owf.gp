# Download municipal area and development layer rasters.
# - assumes that the private GitHub repo has been cloned parallel to other repos
# - copy the repo files to the 'layers' folder
# 
# Location of repository.
SetProperty(PropertyName="WWRRepoFolder",PropertyType="str",PropertyValue="../../../../owf-infomapper-coagtransfer-data-wwr")
#
# ============================
# Municipality Raster
#
# Original CRS is EPSG:4269 so OK to copy directly to layers.
CopyFile(SourceFile="${WWRRepoFolder}/Rasters/Municipality.tif",DestinationFile="layers/Municipality.tif")
#
# ============================
# Land Development Raster
#
# The original file from WWR is EPSG:4269 NAD 83.
CopyFile(SourceFile="${WWRRepoFolder}/Rasters/LandDevelopment.tif",DestinationFile="downloads/LandDevelopment.tif")
#
# Convert to EPSG:4326 WGS 84 and save to the 'layers' folder.
ReadRasterGeoLayerFromFile(InputFile="downloads/LandDevelopment.tif",GeoLayerID="LandDevelopmentRasterLayer",Name="Colorado Land Development (Raster)",Description="Colorado Land Development area derived from polygons")
