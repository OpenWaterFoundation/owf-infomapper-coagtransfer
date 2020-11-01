# Create product for counties
# - currently this relies on the supporting data for Counties
# - just copy the markdown file to the published location
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/BaselineScenario/01-CountyPopulation")
# = = = = = = = = = =
# Write the map project file and copy layers to the location needed by the web application.
# - follow InfoMapper conventions
CreateFolder(Folder="${MapFolder}",CreateParentFolders="True",IfFolderExists="Ignore")
CopyFile(SourceFile="county-population.md",DestinationFile="${MapFolder}/county-population.md")
