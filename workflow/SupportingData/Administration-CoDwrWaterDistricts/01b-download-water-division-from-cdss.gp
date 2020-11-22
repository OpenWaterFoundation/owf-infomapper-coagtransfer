# Download division boundary file.
# - use the zipped shapefile on the CDSS website
# - this should only need to be done if setting up a new workspace
# - apparently the 'DIV3' in the filename means version 3 and not 'Division 3'?
WebGet(URL="https://dnrftp.state.co.us/CDSS/GIS/DIV3CO.zip",OutputFile="downloads/DIV3CO.zip")
# Unzip the zip file
UnzipFile(File="downloads/DIV3CO.zip",OutputFolder="downloads/DIV3CO",IfFolderDoesNotExist="Create")
# Read the 'downloads' shapefile and write to 'layers/'as a GeoJSON file.
ReadGeoLayerFromShapefile(InputFile="downloads/DIV3CO/DIV3CO.shp",GeoLayerID="WaterDivisionsLayer",Name="DWR Division Boundaries",Description="DWR Division Boundaries")
WriteGeoLayerToGeoJSON(GeoLayerID="WaterDivisionsLayer",OutputFile="layers/co-dwr-water-divisions.geojson")
