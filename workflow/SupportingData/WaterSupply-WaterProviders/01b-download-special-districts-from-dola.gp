StartLog(LogFile="01b-download-special-districts-from-dola.gp.log")
# Download statewide water and sanitation special districts boundary polygon layer from DOLA.
# - this layer is used to for area calculations
# - this should only need to be done periodically
# - use the dataset on DOLA's website
# - save the file in 'downloads/' and then copy to 'layers/' folder
#
# Download the full DOLA special districts layer.
WebGet(URL="https://storage.googleapis.com/co-publicdata/dlall.zip",OutputFile="downloads/special-district-boundaries.zip")
# Unzip the shapefile, read, and save to a GeoJSON file
UnzipFile(File="downloads/special-district-boundaries.zip",OutputFolder="downloads/special-districts",IfFolderDoesNotExist="Create")
ReadGeoLayerFromShapefile(InputFile="downloads/special-districts/data/dlall.shp",GeoLayerID="SpecialDistricts0Layer",Name="Water and Sanitation Districts",Description="Water and Sanitation Districts, from DOLA")
#
# TODO smalers 2020-11-16 this is a subset of special districts with only water districts (does not include metro districts)
# Also download the "Water and Sanitation Districts in Colorado" dataset,
# - https://data.colorado.gov/Local-Aggregation/Water-and-Sanitation-Districts-in-Colorado/d6bs-3kgu
# - https://data.colorado.gov/api/geospatial/d6bs-3kgu?method=export&format=GeoJSON
#ReadGeoLayerFromGeoJSON(InputFile="https://data.colorado.gov/api/geospatial/d6bs-3kgu?method=export&format=GeoJSON",GeoLayerID="WaterAndSanitationDistrictsLayer",Name="Water and Sanitation Districts",Description="Water and Sanitation Districts from DOLA")
#
# Copy the initial water districts layer so it can be filtered down to only water districts.
# - start with the layer that has the most boundaries
CopyGeoLayer(GeoLayerID="SpecialDistricts0Layer",OutputGeoLayerID="SpecialDistrictsLayer")
#CopyGeoLayer(GeoLayerID="WaterAndSanitationDistrictsLayer",OutputGeoLayerID="WaterProvidersLayer")
# Read the list of identifiers to include in the model:
# - read DOLA_LG_ID as a string to preserve leading zero
ReadTableFromDelimitedFile(InputFile="data/water-entities-master-list2.csv",TableID="WaterProvidersTable",TextColumns="DOLA_LG_ID_Full")
# Remove features that do not match the list of entities of interest for the analyiss.
RemoveGeoLayerFeatures(GeoLayerID="SpecialDistrictsLayer",MatchAttribute="LGID",IncludeTableID="WaterProvidersTable",IncludeTableColumn="DOLA_LG_ID_Full")
#RemoveGeoLayerFeatures(GeoLayerID="WaterProvidersLayer",MatchAttribute="lgid",IncludeTableID="WaterProvidersTable",IncludeTableColumn="DOLA_LG_ID_Full")
#
# Copy to the 'layers' folder.
WriteGeoLayerToGeoJSON(GeoLayerID="SpecialDistrictsLayer",OutputFile="downloads/special-district-boundaries.geojson")
#WriteGeoLayerToGeoJSON(GeoLayerID="WaterAndSanitationDistrictsLayer",OutputFile="downloads/water-and-sanitation-district-boundaries.geojson")
#WriteGeoLayerToGeoJSON(GeoLayerID="WaterProvidersLayer",OutputFile="downloads/water-provider-boundaries.geojson")
CopyFile(SourceFile="downloads/special-district-boundaries.geojson",DestinationFile="layers/special-district-boundaries.geojson")
#
# Read in the Arapahoe County Water and Wastewater Authority's boundary from KML file hosted on their website.
# 1. View the website in a browser:  https://www.google.com/maps/d/u/0/viewer?mid=1vlGZrFPnhBX-mSSnnkN_T6nJMgU&ll=39.58385025572299%2C-104.805972&z=13
# 2. Manually save to 'downloads/ACWWA.kml' (default name)
# 3. Automate reading in and saving below.
ReadGeoLayerFromKML(InputFile="downloads/ACWWA.kml",InputLayerName="ACWWA Service Area",GeoLayerID="ACWWALayer",Name="Arapaho County Water and Wastewater Authority",Description="Arapaho County Water and Wastewater Authority service area boundary from website")
RemoveGeoLayerAttributes(GeoLayerID="ACWWALayer",AttributeNames="Name,description,timestamp,begin,end,altitudeMode,tessellate,extrude,visibility,drawOrder,icon")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="LGID",AttributeType="string",InitialValue="64247")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="SOURCE",AttributeType="string",InitialValue="ACWWA website Google Map")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="LGNAME",AttributeType="string",InitialValue="Arapahoe County Water and Wastewater Authority")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="LGTYPEID",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="LGSTATUSID",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="ABBREV_NAM",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="MAIL_ADDRE",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="ALT_ADDRES",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="MAIL_CITY",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="MAIL_STATE",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="MAIL_ZIP",AttributeType="string")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="URL",AttributeType="string",InitialValue="acwwa.com")
AddGeoLayerAttribute(GeoLayerID="ACWWALayer",AttributeName="PREV_NAME",AttributeType="string")
#
# Merge the special districts and ACWWA layer into water providers layer
ConvertGeoLayerGeometry(InputGeoLayerID="ACWWALayer",OutputGeometry="Polygon",OutputGeoLayerID="ACWWAPolygonLayer")
MergeGeoLayers(GeoLayerIDs="SpecialDistrictsLayer,ACWWAPolygonLayer",OutputGeoLayerID="WaterProvidersLayer",Name="Water Providers",Description="Water Providers (DOLA districts and ACWWA)")
RemoveGeoLayerAttributes(GeoLayerID="WaterProvidersLayer",AttributeNames="layer,path")
WriteGeoLayerToGeoJSON(GeoLayerID="WaterProvidersLayer",OutputFile="layers/water-provider-boundaries.geojson")