# Create product for synopsis
# - just copy the markdown file to the published location
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/SupportingData/Synopsis")
# = = = = = = = = = =
# Copy files to the location needed by the web application.
# - follow InfoMapper conventions
CreateFolder(Folder="${MapFolder}",CreateParentFolders="True",IfFolderExists="Ignore")
CopyFile(SourceFile="synopsis.md",DestinationFile="${MapFolder}/synopsis.md")
