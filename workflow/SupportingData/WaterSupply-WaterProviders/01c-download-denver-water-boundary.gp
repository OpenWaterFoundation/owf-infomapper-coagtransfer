# Download Denver Water Service Area boundary
# - this layer is used for information
# - this should only need to be done periodically
# - save the file in 'downloads/' and then copy to 'layers/' folder
#
# The layer is not available on the web.  It was provided by email after doing a data request.
ReadGeoLayerFromShapefile(InputFile="downloads/DenverWater/DW_ServiceArea.shp",GeoLayerID="DenverWaterBoundaryLayer",Name="Denver Water Service Area",Description="Denver Water Service Area from Denver Water")
WriteGeoLayerToGeoJSON(GeoLayerID="DenverWaterBoundaryLayer",OutputFile="downloads/denver-water-boundary.geojson")
CopyFile(SourceFile="downloads/denver-water-boundary.geojson",DestinationFile="layers/denver-water-boundary.geojson")
#
# ===========================================
# Download Denver Water Service Area Boundary
# - the following was tested before receiving a boundary shapefile from Denver Water - DO NOT USE but keep as FYI
# Found this with a web search:
# https://www.arcgis.com/home/item.html?id=4fc7c324c20443b991446d421d2c9049&sublayer=1#overview
# https://services3.arcgis.com/2xoV6w32MCqBwxNd/arcgis/rest/services/Water_and_Sanitation_District_Map_Boundaries/FeatureServer/1
# WebGet(URL="https://services3.arcgis.com/2xoV6w32MCqBwxNd/arcgis/rest/services/Water_and_Sanitation_District_Map_Boundaries/FeatureServer/1/query?outFields=*&where=1%3D1&f=geojson",OutputFile="downloads/denver-water-boundary.geojson")