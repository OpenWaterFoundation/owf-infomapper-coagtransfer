# Create a GeoMapProject file for irrigated lands
# - read the previously downloaded layer file
# - output to the web folder for use by the InfoMapper
# - layer view groups are added from 1st drawn (bottom) to last drawn (top)
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
#SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/HistoricalData/Agriculture-IrrigatedLands")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/SupportingData/Agriculture-IrrigatedLands")
SetProperty(PropertyName="WWRRepoFolder",PropertyType="str",PropertyValue="../../../../owf-infomapper-coagtransfer-data-wwr")
#
# Create a single map project and map for that project.
# - GeoMapProjectID:  IrrigatedLandsProject
# - GeoMapID:  IrrigatedLandsMap
CreateGeoMapProject(NewGeoMapProjectID="IrrigatedLandsProject",ProjectType="SingleMap",Name="Irrigated Lands",Description="Irrigated lands.",Properties="author:'Open Water Foundation',specificationVersion:'1.0.0'")
CreateGeoMap(NewGeoMapID="IrrigatedLandsMap",Name="Irrigated Lands",Description="Irrigated lands from CDSS.",CRS="EPSG:4326",Properties="extentInitial:'ZoomLevel:-106.705,38.959,7.6',docPath:'irrigated-lands-map.md'")
AddGeoMapToGeoMapProject(GeoMapProjectID="IrrigatedLandsProject",GeoMapID="IrrigatedLandsMap")
# = = = = = = = = = =
# Background layers:  read layers and add a layer view group
# GeoLayerViewGroupID: BackgroundGroup
# - add tile servers from MapBox, Esri, and Google
#
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="BackgroundGroup",Name="Background Layers",Description="Background maps from image servers.",Properties="isBackground: true, selectedInitial: true")
#
# Mapbox background layers
ReadRasterGeoLayerFromTileMapService(InputUrl="https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia3Jpc3RpbnN3YWltIiwiYSI6ImNpc3Rjcnl3bDAzYWMycHBlM2phbDJuMHoifQ.vrDCYwkTZsrA_0FffnzvBw",GeoLayerID="MapBoxSatelliteLayer",Name="Satellite (MapBox)",Description="Satellite background map from MapBox.",Properties="attribution: 'MapBox',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="MapBoxSatelliteLayer",GeoLayerViewID="MapBoxSatelliteLayerView",Name="Satellite (MapBox)",Description="Satellite background map from MapBox.",Properties="selectedInital: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoia3Jpc3RpbnN3YWltIiwiYSI6ImNpc3Rjcnl3bDAzYWMycHBlM2phbDJuMHoifQ.vrDCYwkTZsrA_0FffnzvBw",GeoLayerID="MapBoxStreetsLayer",Name="Streets (MapBox)",Description="Streets background map from MapBox.",Properties="attribution: 'MapBox',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="MapBoxStreetsLayer",GeoLayerViewID="MapBoxStreetsLayerView",Name="Streets (MapBox)",Description="Streets background map from MapBox.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://api.mapbox.com/v4/mapbox.streets-satellite/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoia3Jpc3RpbnN3YWltIiwiYSI6ImNpc3Rjcnl3bDAzYWMycHBlM2phbDJuMHoifQ.vrDCYwkTZsrA_0FffnzvBw",GeoLayerID="MapBoxStreets&SatelliteLayer",Name="Streets & Satellite (MapBox)",Description="Streets and satellite background map from MapBox.",Properties="attribution: 'MapBox',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="MapBoxStreets&SatelliteLayer",GeoLayerViewID="MapBoxStreets&SatelliteLayerView",Name="Streets & Satellite (MapBox)",Description="Streets and satellite background map from MapBox.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://api.mapbox.com/styles/v1/masforce/cjs108qje09ld1fo68vh7t1he/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFzZm9yY2UiLCJhIjoiY2pzMTA0bmR5MXAwdDN5bnIwOHN4djBncCJ9.ZH4CfPR8Q41H7zSpff803g",GeoLayerID="MapBoxTopographicLayer",Name="Topographic (MapBox)",Description="Topographic background map from MapBox.",Properties="attribution: 'MapBox',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="MapBoxTopographicLayer",GeoLayerViewID="MapBoxTopographicLayerView",Name="Topographic (MapBox)",Description="Topographic Map",Properties="selectedInitial: false")
#
# Esri background layers
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriDarkGray",Name="Dark Gray (Esri)",Description="Dark Gray background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriDarkGray",GeoLayerViewID="EsriDarkGrayView",Name="Dark Gray (Esri)",Description="Dark Gray background map from Esri.",Properties="selectedInitial: false,separatorBefore:true")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriImagery",Name="Imagery (Esri)",Description="Imagery background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriImagery",GeoLayerViewID="EsriImageryView",Name="Imagery (Esri)",Description="Imagery background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriLightGray",Name="Light Gray (Esri)",Description="Light Gray background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriLightGray",GeoLayerViewID="EsriLightGrayView",Name="Light Gray (Esri)",Description="Light Gray background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriNationalGeographic",Name="National Geographic (Esri)",Description="National Geographic background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriNationalGeographic",GeoLayerViewID="EsriNationalGeographicView",Name="National Geographic (Esri)",Description="National Geographic background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriShadedRelief",Name="Shaded Relief (Esri)",Description="Shaded Relief background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriShadedRelief",GeoLayerViewID="EsriShadedReliefView",Name="Shaded Relief (Esri)",Description="Terrain background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriStreets",Name="Streets (Esri)",Description="Streets background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriStreets",GeoLayerViewID="EsriStreetsView",Name="Streets (Esri)",Description="Streets background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/World_Terrain_Base/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriTerrain",Name="Terrain (Esri)",Description="Terrain background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriTerrain",GeoLayerViewID="EsriTerrainView",Name="Terrain (Esri)",Description="Terrain background map from Esri.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="https://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",GeoLayerID="EsriTopographic",Name="Topographic (Esri)",Description="Topographic background map from Esri.",Properties="attribution: 'Esri',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="EsriTopographic",GeoLayerViewID="EsriTopographicView",Name="Topographic (Esri)",Description="Topographic background map from Esri.",Properties="selectedInitial: false")
#
# Google background layers
ReadRasterGeoLayerFromTileMapService(InputUrl="http://mt0.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",GeoLayerID="GoogleSatellite",Name="Satellite (Google)",Description="Satellite background map from Google.",Properties="attribution: 'Google',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleSatellite",GeoLayerViewID="GoogleSatelliteView",Name="Satellite (Google)",Description="Satellite background map from Google.",Properties="selectedInitial: false,separatorBefore:true")
ReadRasterGeoLayerFromTileMapService(InputUrl="http://mt0.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",GeoLayerID="GoogleStreets",Name="Streets (Google)",Description="Streets background map from Google.",Properties="attribution: 'Google',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleStreets",GeoLayerViewID="GoogleStreetsView",Name="Streets (Google)",Description="Streets background map from Google.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="http://mt0.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}",GeoLayerID="GoogleHybrid",Name="Streets & Satellite (Google)",Description="Streets & satellite background map from Google.",Properties="attribution: 'Google',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleHybrid",GeoLayerViewID="GoogleHybridView",Name="Streets & Satellite (Google)",Description="Streets & satellite background map from Google.",Properties="selectedInitial: true")
ReadRasterGeoLayerFromTileMapService(InputUrl="http://mt0.google.com/vt/lyrs=p&x={x}&y={y}&z={z}",GeoLayerID="GoogleTerrain",Name="Terrain (Google)",Description="Terrain background map from Google.",Properties="attribution: 'Google',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleTerrain",GeoLayerViewID="GoogleTerrainView",Name="Terrain (Google)",Description="Terrain background map from Google.",Properties="selectedInitial: false")
# Other
ReadRasterGeoLayerFromTileMapService(InputUrl="https://basemap.nationalmap.gov/ArcGIS/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}",GeoLayerID="USGSTopo",Name="USGS Topo (USGS)",Description="Topo background map from USGS.",Properties="attribution: 'USGS',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="USGSTopo",GeoLayerViewID="USGSTopoView",Name="USGS Topo (USGS)",Description="USGS Topo background map from USGS.",Properties="selectedInitial: false,separatorBefore:true")
# = = = = = = = = = =
# Irrigated Lands raster data:  read layers and add to a layer view group.
# - copy from the repository that contains WWR data
# GeoLayerViewGroupID: IrrigatedLandsRasterGroup
#
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="IrrigatedLandsRasterGroup",Name="Irrigated Lands (Raster)",Description="Irrigated lands area derived from parcel polygons",InsertPosition="Top")
#
CopyFile(SourceFile="${WWRRepoFolder}/Rasters/Irrigation.tif",DestinationFile="layers/Irrigation.tif")
ReadRasterGeoLayerFromFile(InputFile="layers/Irrigation.tif",GeoLayerID="IrrigatedLandsRasterLayer",Name="Irrigated Lands (Raster)",Description="Irrigated lands area derived from parcel polygons")
AddGeoLayerViewToGeoMap(GeoLayerID="IrrigatedLandsRasterLayer",GeoLayerViewID="IrrigatedLandsRasterLayerView",Name="Irrigated Lands (Raster)",Description="Irrigated lands area derived from parcel polygons",Properties="docPath:'layers/Irrigation.md'")
# Use category colors
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="IrrigatedLandsRasterLayerView",Name="Colorize Irrigated Lands",Description="Symbol for the irrigated lands raster",ClassificationAttribute="1",Properties="classificationFile:'layers/Irrigation-classify-irrigation.csv'")
SetGeoLayerViewEventHandler(GeoLayerViewID="IrrigatedLandsRasterLayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/Irrigation-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="IrrigatedLandsRasterLayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/Irrigation-event-config.json")
# = = = = = = = = = =
# Irrigated lands
# - select the most recent for initial view
# = = = = = = = = = =
# Irrigated lands (1956):  read layer and add to a layer view group.
# GeoLayerViewGroupID: IrrigatedLandsGroup
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="IrrigatedLandsGroup",Name="Irrigated Lands",Description="Irrigated lands from Colorado's Decision Support System.",InsertPosition="Top")
#
# = = = = = = = = = =
# Republican Irrigated lands (2019):  read layer and add to a layer view group.
# GeoLayerViewGroupID: IrrigatedLandsGroup
# - not currently included even though raster area does overlap republican
#ReadGeoLayerFromGeoJSON(InputFile="layers/republican-irrigated-lands-2019.geojson",GeoLayerID="RepublicanIrrigatedLands2019Layer",Name="Republican Irrigated Lands (2019)",Description="Republican irrigated lands (2019) from CDSS.")
#AddGeoLayerViewToGeoMap(GeoLayerID="RepublicanIrrigatedLands2019Layer",GeoLayerViewID="RepublicanIrrigatedLands2019LayerView",Name="Republican Irrigated Lands (2019)",Description="Republican irrigated lands (2019) from CDSS",InsertPosition="Top",Properties="docPath:layers/irrigated-lands.md,selectedInitial:true")
#SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="RepublicanIrrigatedLands2019LayerView",Name="Colorize irrigated lands by crop type",Description="Show each irrigated parcel colored by crop type.",ClassificationAttribute="CROP_TYPE",Properties="classificationType:'categorized',classificationFile:'layers/irrigated-lands-classify-croptype.csv'")
#SetGeoLayerViewEventHandler(GeoLayerViewID="RepublicanIrrigatedLands2019LayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2018-event-config.json")
#SetGeoLayerViewEventHandler(GeoLayerViewID="RepublicanIrrigatedLands2019LayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2018-event-config.json")
#
# = = = = = = = = = =
# Division 2 Irrigated lands (2015):  read layer and add to a layer view group.
# GeoLayerViewGroupID: IrrigatedLandsGroup
ReadGeoLayerFromGeoJSON(InputFile="layers/div2-irrigated-lands-2015.geojson",GeoLayerID="Div2IrrigatedLands2015Layer",Name="Arkansas Irrigated Lands (2015)",Description="Arkansas (Division 2) irrigated lands (2015) from CDSS.")
AddGeoLayerViewToGeoMap(GeoLayerID="Div2IrrigatedLands2015Layer",GeoLayerViewID="Div2IrrigatedLands2015LayerView",Name="Arkansas Irrigated Lands (2015)",Description="Arkansas (Division 2) irrigated lands (2015) from CDSS",InsertPosition="Top",Properties="docPath:layers/irrigated-lands.md,selectedInitial:true")
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="Div2IrrigatedLands2015LayerView",Name="Colorize irrigated lands by crop type",Description="Show each irrigated parcel colored by crop type.",ClassificationAttribute="CROP_TYPE",Properties="classificationType:'categorized',classificationFile:'layers/irrigated-lands-classify-croptype.csv'")
SetGeoLayerViewEventHandler(GeoLayerViewID="Div2IrrigatedLands2015LayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2015-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="Div2IrrigatedLands2015LayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2015-event-config.json")
#
# = = = = = = = = = =
# Division 2 Irrigated lands (2018):  read layer and add to a layer view group.
# Enable this in the future when moving forward
# GeoLayerViewGroupID: IrrigatedLandsGroup
#ReadGeoLayerFromGeoJSON(InputFile="layers/div2-irrigated-lands-2018.geojson",GeoLayerID="Div2IrrigatedLands2018Layer",Name="Arkansas Irrigated Lands (2018)",Description="Arkansas (Division 2) irrigated lands (2018) from CDSS.")
#AddGeoLayerViewToGeoMap(GeoLayerID="Div2IrrigatedLands2018Layer",GeoLayerViewID="Div2IrrigatedLands2018LayerView",Name="Arkansas Irrigated Lands (2018)",Description="Arkansas (Division 2) irrigated lands (2018) from CDSS",InsertPosition="Top",Properties="docPath:layers/irrigated-lands.md,selectedInitial:true")
#SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="Div2IrrigatedLands2018LayerView",Name="Colorize irrigated lands by crop type",Description="Show each irrigated parcel colored by crop type.",ClassificationAttribute="CROP_TYPE",Properties="classificationType:'categorized',classificationFile:'layers/irrigated-lands-classify-croptype.csv'")
#SetGeoLayerViewEventHandler(GeoLayerViewID="Div2IrrigatedLands2018LayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2018-event-config.json")
#SetGeoLayerViewEventHandler(GeoLayerViewID="Div2IrrigatedLands2018LayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/div2-irrigated-lands-2018-event-config.json")
#
# = = = = = = = = = =
# Division 1 Irrigated lands (2015):  read layer and add to a layer view group.
# GeoLayerViewGroupID: IrrigatedLandsGroup
ReadGeoLayerFromGeoJSON(InputFile="layers/div1-irrigated-lands-2015.geojson",GeoLayerID="Div1IrrigatedLands2015Layer",Name="South Platte Irrigated Lands (2015)",Description="South Platte (Division 1) irrigated lands (2015) from CDSS.")
AddGeoLayerViewToGeoMap(GeoLayerID="Div1IrrigatedLands2015Layer",GeoLayerViewID="Div1IrrigatedLands2015LayerView",Name="South Platte Irrigated Lands (2015)",Description="South Platte (Division 1) irrigated lands (2015) from CDSS",InsertPosition="Top",Properties="docPath:layers/irrigated-lands.md,selectedInitial:true")
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="Div1IrrigatedLands2015LayerView",Name="Colorize irrigated lands by crop type",Description="Show each irrigated parcel colored by crop type.",ClassificationAttribute="CROP_TYPE",Properties="classificationType:'categorized',classificationFile:'layers/irrigated-lands-classify-croptype.csv'")
SetGeoLayerViewEventHandler(GeoLayerViewID="Div1IrrigatedLands2015LayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/div1-irrigated-lands-2015-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="Div1IrrigatedLands2015LayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/div1-irrigated-lands-2015-event-config.json")
# = = = = = = = = = =
# Write the map project file and copy layers to the location needed by the web application.
# - follow InfoMapper conventions
WriteGeoMapProjectToJSON(GeoMapProjectID="IrrigatedLandsProject",Indent="2",OutputFile="irrigated-lands-map.json")
CreateFolder(Folder="${MapFolder}/layers",CreateParentFolders="True",IfFolderExists="Ignore")
CopyFile(SourceFile="irrigated-lands-map.json",DestinationFile="${MapFolder}/irrigated-lands-map.json")
CopyFile(SourceFile="irrigated-lands-map.md",DestinationFile="${MapFolder}/irrigated-lands-map.md")
#
CopyFile(SourceFile="layers/div1-irrigated-lands-2015.geojson",DestinationFile="${MapFolder}/layers/div1-irrigated-lands-2015.geojson")
CopyFile(SourceFile="layers/div1-irrigated-lands-2015-event-config.json",DestinationFile="${MapFolder}/layers/div1-irrigated-lands-2015-event-config.json")
#
CopyFile(SourceFile="layers/div2-irrigated-lands-2015.geojson",DestinationFile="${MapFolder}/layers/div2-irrigated-lands-2015.geojson")
CopyFile(SourceFile="layers/div2-irrigated-lands-2015-event-config.json",DestinationFile="${MapFolder}/layers/div2-irrigated-lands-2015-event-config.json")
# Div 2 2018 is for the future
#CopyFile(SourceFile="layers/div2-irrigated-lands-2018.geojson",DestinationFile="${MapFolder}/layers/div2-irrigated-lands-2018.geojson")
#CopyFile(SourceFile="layers/div2-irrigated-lands-2018-event-config.json",DestinationFile="${MapFolder}/layers/div2-irrigated-lands-2018-event-config.json")
#
# Republican is not included
#CopyFile(SourceFile="layers/republican-irrigated-lands-2019.geojson",DestinationFile="${MapFolder}/layers/republican-irrigated-lands-2019.geojson")
#CopyFile(SourceFile="layers/republican-irrigated-lands-2019-event-config.json",DestinationFile="${MapFolder}/layers/republican-irrigated-lands-2019-event-config.json")
#
CopyFile(SourceFile="layers/irrigated-lands-classify-croptype.csv",DestinationFile="${MapFolder}/layers/irrigated-lands-classify-croptype.csv")
#
CopyFile(SourceFile="layers/irrigated-lands.md",DestinationFile="${MapFolder}/layers/irrigated-lands.md")
# Rasters
CopyFile(SourceFile="layers/Irrigation.tif",DestinationFile="${MapFolder}/layers/Irrigation.tif")
CopyFile(SourceFile="layers/Irrigation.md",DestinationFile="${MapFolder}/layers/Irrigation.md")
CopyFile(SourceFile="layers/Irrigation-classify-irrigation.csv",DestinationFile="${MapFolder}/layers/Irrigation-classify-irrigation.csv")
CopyFile(SourceFile="layers/Irrigation-event-config.json",DestinationFile="${MapFolder}/layers/Irrigation-event-config.json")
