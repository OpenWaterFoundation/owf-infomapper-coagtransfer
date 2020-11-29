# Convert land development rasters CRS to EPSG:4326
# - assumes that the private GitHub repo has been cloned parallel to other repos
# - copy the repo files to the 'layers' folder
#
# Location of repository.
SetProperty(PropertyName="AnalysisFolder",PropertyType="str",PropertyValue="../../../workflow-v1/data-processing/11-Map-LandDevelopment")
#
# ============================
# Municipal land development raster
#
# Original CRS is EPSG:31967
CopyFile(SourceFile="${AnalysisFolder}/Low_Density_Municipal_Growth.tif",DestinationFile="downloads/Low_Density_Municipal_Growth.tif")
CopyFile(SourceFile="${AnalysisFolder}/Medium_Density_Municipal_Growth.tif",DestinationFile="downloads/Medium_Density_Municipal_Growth.tif")
CopyFile(SourceFile="${AnalysisFolder}/High_Density_Municipal_Growth.tif",DestinationFile="downloads/High_Density_Municipal_Growth.tif")
CopyFile(SourceFile="${AnalysisFolder}/District_Growth.tif",DestinationFile="downloads/District_Growth.tif")
#
# Municipal Low Density Growth
# Convert to EPSG:4326 WGS 84 and save to the 'layers' folder.
ReadRasterGeoLayerFromFile(InputFile="downloads/Low_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",Name="Municipal Land Development, Low Density (Raster)",Description="Municipal land development, low density")
ChangeRasterGeoLayerCRS(GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",CRS="EPSG:4326")
RearrangeRasterGeoLayerBands(GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",Bands="7")
WriteRasterGeoLayerToFile(GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",OutputFile="layers/Low_Density_Municipal_Growth.tif")
#
# Municipal Medium Density Growth
ReadRasterGeoLayerFromFile(InputFile="downloads/Medium_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentMediumDensityRasterLayer",Name="Municipal Land Development, Medium Density (Raster)",Description="Municipal land development, medium density")
ChangeRasterGeoLayerCRS(GeoLayerID="MunicipalLandDevelopmentMediumDensityRasterLayer",CRS="EPSG:4326")
RearrangeRasterGeoLayerBands(GeoLayerID="MunicipalLandDevelopmentMediumDensityRasterLayer",Bands="7")
WriteRasterGeoLayerToFile(GeoLayerID="MunicipalLandDevelopmentMediumDensityRasterLayer",OutputFile="layers/Medium_Density_Municipal_Growth.tif")
#
# Municipal High Density Growth
ReadRasterGeoLayerFromFile(InputFile="downloads/High_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",Name="Municipal Land Development, High Density (Raster)",Description="Municipal land development, high density")
ChangeRasterGeoLayerCRS(GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",CRS="EPSG:4326")
RearrangeRasterGeoLayerBands(GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",Bands="7")
WriteRasterGeoLayerToFile(GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",OutputFile="layers/High_Density_Municipal_Growth.tif")
#
# District Growth
ReadRasterGeoLayerFromFile(InputFile="downloads/District_Growth.tif",GeoLayerID="DistrictGrowthRasterLayer",Name="District Growth (Raster)",Description="District growth")
ChangeRasterGeoLayerCRS(GeoLayerID="DistrictGrowthRasterLayer",CRS="EPSG:4326")
RearrangeRasterGeoLayerBands(GeoLayerID="DistrictGrowthRasterLayer",Bands="7")
WriteRasterGeoLayerToFile(GeoLayerID="DistrictGrowthRasterLayer",OutputFile="layers/District_Growth.tif")
#
# Print algorithm help.
# QgisAlgorithmHelp(AlgorithmIDs="gdal:translate",ShowHelp="False")