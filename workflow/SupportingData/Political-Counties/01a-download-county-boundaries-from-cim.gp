# Download counties layer.
# - this should only need to be done periodically
# - download from Colorado Information Marketplace
WebGet(URL="https://data.colorado.gov/resource/ahgn-r8s5.geojson",OutputFile="downloads/counties.geojson",Timeout="10")
#
# Don't do this because CIM layer has 15 digits.  Cut back to 5 to reduce file size
# Copy to the 'layers' folder.  If clipping to the Poudre is implemented, use a 02* command file.
#CopyFile(SourceFile="downloads/counties.geojson",DestinationFile="layers/counties.geojson")
#
# Read the file from 'downloads/' and rewrite to 'layers/' to cut back on the number digits
ReadGeoLayerFromGeoJSON(InputFile="downloads/counties.geojson",GeoLayerID="CountiesLayer",Name="Counties",Description="Counties")
WriteGeoLayerToGeoJSON(GeoLayerID="CountiesLayer",OutputFile="layers/counties.geojson")