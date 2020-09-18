# Download Water Districts file.
# - output is a layer with water districts for the entire state
# - use the zipped shapefile on the CDSS website
# - this should only need to be done if setting up a new workspace
WebGet(URL="https://dnrftp.state.co.us/CDSS/GIS/Water_Districts.zip",OutputFile="downloads/Water_Districts.zip")
# Unzip the zip file
UnzipFile(File="downloads/Water_Districts.zip",OutputFolder="downloads/Water_Districts",IfFolderDoesNotExist="Create")
# Read the 'downloads' shapefile and write to 'layers/'as a GeoJSON file.
ReadGeoLayerFromShapefile(InputFile="downloads/Water_Districts/Water_Districts.shp",GeoLayerID="WaterDistrictsLayer",Name="DWR Water Districts",Description="DWR Water Districts for Division 1")
WriteGeoLayerToGeoJSON(GeoLayerID="WaterDistrictsLayer",OutputFile="layers/co-dwr-water-districts.geojson")
