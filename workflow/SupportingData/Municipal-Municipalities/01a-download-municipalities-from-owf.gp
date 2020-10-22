# Download Poudre Basin municipalities from OWF
# - contains point data, not boundaries
# - this should only need to be done periodically
# - use the file in the OWF GitHub repository
# - save the file in 'downloads/' and then copy to 'layers/' folder
# - TODO smalers 2020-06-14 will need to clip to the Poudre if the dataset is expanded
WebGet(URL="https://raw.githubusercontent.com/OpenWaterFoundation/owf-data-co-municipalities/master/data/Colorado-Municipalities.geojson",OutputFile="downloads/municipalities.geojson")
# Copy to the 'layers' folder.  If clipping to the Poudre is implemented, use a 02* command file.
CopyFile(SourceFile="downloads/municipalities.geojson",DestinationFile="layers/municipalities.geojson")
#
# Also need the csv to use with TSTool
WebGet(URL="https://raw.githubusercontent.com/OpenWaterFoundation/owf-data-co-municipalities/master/data/Colorado-Municipalities.csv",OutputFile="downloads/municipalities-owf.csv")
