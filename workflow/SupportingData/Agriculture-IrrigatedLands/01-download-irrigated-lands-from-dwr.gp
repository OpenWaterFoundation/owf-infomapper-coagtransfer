# Download Division 1 Irrigated Lands files.
# - this should only need to be done periodically
# - use the file on the OWF website since it has already been clipped for District 3
# - save the file in 'downloads' and then read and write to make sure GeoJSON uses the latest specification
#
# South Platte Division 1 (no Republican) 2015 Irrigated Lands
# - use shapefiles so don't need to deal with full GeoDatabase
WebGet(URL="https://dnrftp.state.co.us/CDSS/GIS/Div1_Irrigated_Lands_2015.zip",OutputFile="downloads/Div1_Irrigated_Lands_2015.zip")
# Unzip the shapefile, read, and save to a GeoJSON file
UnzipFile(File="downloads/Div1_Irrigated_Lands_2015.zip",OutputFolder="downloads",IfFolderDoesNotExist="Create")
ReadGeoLayerFromShapefile(InputFile="downloads/Div1_Irrigated_Lands_2015/Div1_Irrig_2015/Div1_Irrig_2015.shp",GeoLayerID="Div1IrrigatedLands2015Layer",Name="South Platte Irrigated Lands (2015)",Description="South Platte (Division 1) irrigated lands (2015) from DWR")
WriteGeoLayerToGeoJSON(GeoLayerID="Div1IrrigatedLands2015Layer",OutputFile="layers/div1-irrigated-lands-2015.geojson")
#
# South Platte Division 1 (Republican) 2015 Irrigated Lands
# - use shapefiles so don't need to deal with full GeoDatabase
WebGet(URL="https://dnrftp.state.co.us/CDSS/GIS/Republican_Shapefiles.zip",OutputFile="downloads/Republican_Shapefiles.zip")
# Unzip the shapefile, read, and save to a GeoJSON file
UnzipFile(File="downloads/Republican_Shapefiles.zip",OutputFolder="downloads",IfFolderDoesNotExist="Create")
ReadGeoLayerFromShapefile(InputFile="downloads/Republican_Shapefiles/Repub_Irrig_2019.shp",GeoLayerID="RepublicanIrrigatedLands2019Layer",Name="Republican Basin Irrigated Lands (2019)",Description="Republican Basin irrigated lands (2019) from DWR")
WriteGeoLayerToGeoJSON(GeoLayerID="RepublicanIrrigatedLands2019Layer",OutputFile="layers/republican-irrigated-lands-2019.geojson")
#
# Arkansas Division 2 2015 Irrigated Lands
# - use shapefiles so don't need to deal with full GeoDatabase
WebGet(URL="https://dnrftp.state.co.us/CDSS/GIS/Div2_Irrigated_Shapefiles.zip",OutputFile="downloads/Div2_Irrigated_Shapefiles.zip")
# Unzip the shapefile, read, and save to a GeoJSON file
UnzipFile(File="downloads/Div2_Irrigated_Shapefiles.zip",OutputFolder="downloads",IfFolderDoesNotExist="Create")
ReadGeoLayerFromShapefile(InputFile="downloads/ARKDSS_Shapefiles/Div2_Irrig_2015.shp",GeoLayerID="Div2IrrigatedLands2015Layer",Name="Arkansas Irrigated Lands (2015)",Description="Arkansas (Division 2) irrigated lands (2015) from DWR")
WriteGeoLayerToGeoJSON(GeoLayerID="Div2IrrigatedLands2015Layer",OutputFile="layers/div2-irrigated-lands-2015.geojson")
#
# Arkansas Division 2 2018 Irrigated Lands
# - WWR study used 2015 so 2018 is for future update
# - use shapefiles so don't need to deal with full GeoDatabase
ReadGeoLayerFromShapefile(InputFile="downloads/ARKDSS_Shapefiles/Div2_Irrig_2018.shp",GeoLayerID="Div2IrrigatedLands2018Layer",Name="Arkansas Irrigated Lands (2018)",Description="Arkansas (Division 2) irrigated lands (2018) from DWR")
WriteGeoLayerToGeoJSON(GeoLayerID="Div2IrrigatedLands2018Layer",OutputFile="layers/div2-irrigated-lands-2018.geojson")
