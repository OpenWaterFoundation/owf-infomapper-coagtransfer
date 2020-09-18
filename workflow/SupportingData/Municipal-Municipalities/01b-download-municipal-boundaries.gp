# Download municipal boundaries layer.
# - this should only need to be done periodically
# - download from Colorado Information Marketplace
WebGet(URL="https://data.colorado.gov/resource/w6jq-7em5.geojson",OutputFile="downloads/municipal-boundaries.geojson",Timeout="10")
# Don't do the following because CIM layer has 14 digits... cut it back
# Copy to the 'layers' folder.  If clipping to the Poudre is implemented, use a 02* command file.
#CopyFile(SourceFile="downloads/municipal-boundaries.geojson",DestinationFile="layers/municipal-boundaries.geojson")
# Read the file from 'downloads/' and rewrite to 'layers/' to make sure the latest GeoJSON spec and fewer digits are used.
ReadGeoLayerFromGeoJSON(InputFile="downloads/municipal-boundaries.geojson",GeoLayerID="MunicipalBoundariesLayer",Name="Municipal Boundaries",Description="Municipal Boundaries (latest)")
WriteGeoLayerToGeoJSON(GeoLayerID="MunicipalBoundariesLayer",OutputFile="layers/municipal-boundaries.geojson")
