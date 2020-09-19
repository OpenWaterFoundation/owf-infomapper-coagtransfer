# Download Poudre Basin water providers.
# - this should only need to be done periodically
# - use the file in the OWF GitHub repository
# - save the file in 'downloads/' and then copy to 'layers/' folder
# - TODO smalers 2020-06-14 will need to clip to the Poudre if the dataset is expanded
WebGet(URL="https://raw.githubusercontent.com/OpenWaterFoundation/owf-data-co-municipal-water-providers/master/data/Colorado-Municipal-Water-Providers.geojson",OutputFile="downloads/water-providers.geojson")
# Copy to the 'layers' folder.  If clipping to the Poudre is implemented, use a 02* command file.
CopyFile(SourceFile="downloads/water-providers.geojson",DestinationFile="layers/water-providers.geojson")
