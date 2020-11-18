# Download statewide water providers point layer OWF dataset.
# - this layer is used to show a marker
# - this should only need to be done periodically
# - use the file in the OWF GitHub repository
# - save the file in 'downloads/' and then copy to 'layers/' folder
WebGet(URL="https://raw.githubusercontent.com/OpenWaterFoundation/owf-data-co-municipal-water-providers/master/data/Colorado-Municipal-Water-Providers.geojson",OutputFile="downloads/water-providers.geojson")
# Copy to the 'layers' folder.  If clipping to the Poudre is implemented, use a 02* command file.
CopyFile(SourceFile="downloads/water-providers.geojson",DestinationFile="layers/water-providers.geojson")
