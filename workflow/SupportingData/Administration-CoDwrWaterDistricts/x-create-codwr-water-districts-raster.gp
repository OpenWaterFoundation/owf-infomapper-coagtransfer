# Test converting water districts polygon layer to raster layers
# - these are not used in the production application but are provided to InfoMapper for testing
# - create an image and also a raster file with geographic units
ReadGeoLayerFromGeoJSON(InputFile="layers/co-dwr-water-districts-division1.geojson",GeoLayerID="districts",Name="districts",Description="districts",IfGeoLayerIDExists="Replace")
#
# Create a raster layer where cell size is in geographic units (degrees)
RasterizeGeoLayer(GeoLayerID="districts",Attribute="DISTRICT",NewGeoLayerID="districtsraster",CellValueType="Integer32",RasterUnits="GeoUnits",CellWidth=".05",CellHeight=".05",IfGeoLayerIDExists="Replace")
WriteRasterGeoLayerToFile(GeoLayerID="districtsraster",OutputFile="layers/districtsraster.tif")
#
# Create a raster layer where cell size is pixels, TIF format
RasterizeGeoLayer(GeoLayerID="districts",Attribute="DISTRICT",NewGeoLayerID="districtsimage",CellValueType="Integer32",RasterUnits="Pixels",RasterWidth="300",RasterHeight="300",IfGeoLayerIDExists="Replace")
WriteRasterGeoLayerToFile(GeoLayerID="districtsimage",OutputFile="layers/districtsimage.tif")
#
# Create a raster layer where cell size is pixels, JPG format
# RasterizeGeoLayer(GeoLayerID="districts",Attribute="DISTRICT",NewGeoLayerID="districtsimagejpg",RasterFormat="JPEG",CellValueType="Integer32",RasterUnits="Pixels",RasterWidth="300",RasterHeight="300",IfGeoLayerIDExists="Replace")
# WriteRasterGeoLayerToFile(GeoLayerID="districtsimagejpg",OutputFile="layers/districtsimage.jpg")