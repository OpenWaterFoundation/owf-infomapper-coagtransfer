# Create a GeoMapProject file for municipality populations, including forecasts
# - read the previously downloaded layer file
# - output to the web folder for use by the InfoMapper
# - layer view groups are added from 1st drawn (bottom) to last drawn (top)
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/BaselineScenario/02-MunicipalityPopulation")
#
# Create a single map project and map for that project.
# - GeoMapProjectID:  BaselineScenarioMunicipalitiesProject
# - GeoMapID:  BaselineScenarioMunicipalitiesMap
CreateGeoMapProject(NewGeoMapProjectID="BaselineScenarioMunicipalitiesProject",ProjectType="SingleMap",Name="Colorado Municipalities",Description="Colorado Municipalities",Properties="author:'Open Water Foundation',specificationFlavor:'',specificationVersion:'1.0.0'")
CreateGeoMap(NewGeoMapID="BaselineScenarioMunicipalitiesMap",Name="Colorado Municipalities",Description="Colorado Municipalities",CRS="EPSG:4326",Properties="extentInitial:'ZoomLevel:-107.473,39.106,7.5',docPath:'municipalities-map.md'")
AddGeoMapToGeoMapProject(GeoMapProjectID="BaselineScenarioMunicipalitiesProject",GeoMapID="BaselineScenarioMunicipalitiesMap")
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
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleHybrid",GeoLayerViewID="GoogleHybridView",Name="Streets & Satellite (Google)",Description="Streets & satellite background map from Google.",Properties="selectedInitial: false")
ReadRasterGeoLayerFromTileMapService(InputUrl="http://mt0.google.com/vt/lyrs=p&x={x}&y={y}&z={z}",GeoLayerID="GoogleTerrain",Name="Terrain (Google)",Description="Terrain background map from Google.",Properties="attribution: 'Google',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="GoogleTerrain",GeoLayerViewID="GoogleTerrainView",Name="Terrain (Google)",Description="Terrain background map from Google.",Properties="selectedInitial: false")
# Other
ReadRasterGeoLayerFromTileMapService(InputUrl="https://basemap.nationalmap.gov/ArcGIS/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}",GeoLayerID="USGSTopo",Name="USGS Topo (USGS)",Description="Topo background map from USGS.",Properties="attribution: 'USGS',isBackground: true")
AddGeoLayerViewToGeoMap(GeoLayerID="USGSTopo",GeoLayerViewID="USGSTopoView",Name="USGS Topo (USGS)",Description="USGS Topo background map from USGS.",Properties="selectedInitial: true,separatorBefore:true")
# = = = = = = = = = =
# Colorado state boundary:  read layer and add to layer view group.
# StateBoundaryGroupID: StateBoundaryGroup
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="StateBoundaryGroup",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE.",Properties="selectedInitial: true",InsertPosition="Top")
#
ReadGeoLayerFromGeoJSON(InputFile="https://opendata.arcgis.com/datasets/4402a8e032ed49eb8b37fd729e4e8f03_9.geojson",GeoLayerID="StateBoundaryLayer",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE.")
AddGeoLayerViewToGeoMap(GeoLayerID="StateBoundaryLayer",GeoLayerViewID="StateBoundaryLayerView",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE",InsertPosition="Top")
SetGeoLayerViewSingleSymbol(GeoLayerViewID="StateBoundaryLayerView",Name="State boundary symbol",Description="State boundary in black.",Properties="color:#000000,opacity:0.0,fillColor:#000000,fillOpacity:0.0,weight:2")
# = = = = = = = = = =
# Municipal boundaries:  read layer and add to a layer view group.
# - TODO smalers 2020-06-13 this seems to hang the app when in production
# GeoLayerViewGroupID: MunicipalBoundariesGroup
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="MunicipalitiesGroup",Name="Colorado Municipalities",Description="Colorado Municipalities",InsertPosition="Top")
#
CopyFile(SourceFile="../../SupportingData/Municipal-Municipalities/layers/municipal-boundaries.geojson",DestinationFile="${MapFolder}/municipal-boundaries.geojson")
ReadGeoLayerFromGeoJSON(InputFile="layers/municipal-boundaries.geojson",GeoLayerID="MunicipalBoundariesLayer",Name="Colorado Municipal Boundaries",Description="Colorado Municipal Boundaries")
AddGeoLayerViewToGeoMap(GeoLayerID="MunicipalBoundariesLayer",GeoLayerViewID="MunicipalBoundariesLayerView",Name="Colorado Municipal Boundaries",Description="Colorado Municipal Boundaries",Properties="docPath:'layers/municipal-boundaries.md'")
# For now use single symbol
# - grey
SetGeoLayerViewSingleSymbol(GeoLayerViewID="MunicipalBoundariesLayerView",Name="Colorado Municipal Boundaries",Description="Colorado Municipal Boundaries",Properties="color:#595959,opacity:1.0,fillColor:#595959,fillOpacity:0.3,weight:2")
SetGeoLayerViewEventHandler(GeoLayerViewID="MunicipalBoundariesLayerView",EventType="click",Properties="eventConfigPath:layers/municipal-boundaries-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="MunicipalBoundariesLayerView",EventType="hover",Properties="eventConfigPath:layers/municipal-boundaries-event-config.json")
# = = = = = = = = = =
# Municipalities:  read layer and add to a layer view group.
# GeoLayerViewGroupID: MunicipalitiesGroup
CopyFile(SourceFile="../../SupportingData/Municipal-Municipalities/layers/municipalities.geojson",DestinationFile="${MapFolder}/municipalities.geojson")
ReadGeoLayerFromGeoJSON(InputFile="layers/municipalities.geojson",GeoLayerID="MunicipalitiesLayer",Name="Colorado Municipalities",Description="Colorado Municipalities")
AddGeoLayerViewToGeoMap(GeoLayerID="MunicipalitiesLayer",GeoLayerViewID="MunicipalitiesLayerView",Name="Colorado Municipalities",Description="Colorado Municipalities",InsertPosition="Top",Properties="docPath:'layers/municipalities.md'")
# For now use single symbol
# - TODO smalers 2020-05-22 need to enable a graduated symbol based on flow value
SetGeoLayerViewSingleSymbol(GeoLayerViewID="MunicipalitiesLayerView",Name="Colorado Municipalities",Description="Colorado Municipalities",Properties="symbolImage:/img/group-2-32x37.png,imageAnchorPoint:Bottom")
# SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="MunicipalitiesLayerView",Name="Colorado Municipalities",Description="Colorado Municipalities",ClassificationAttribute="county",Properties="classificationType:'SingleSymbol'")
SetGeoLayerViewEventHandler(GeoLayerViewID="MunicipalitiesLayerView",EventType="click",Properties="eventConfigPath:layers/municipalities-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="MunicipalitiesLayerView",EventType="hover",Properties="eventConfigPath:layers/municipalities-event-config.json")
# = = = = = = = = = =
# Write the map project file and copy layers to the location needed by the web application.
# - follow InfoMapper conventions
WriteGeoMapProjectToJSON(GeoMapProjectID="BaselineScenarioMunicipalitiesProject",Indent="2",OutputFile="municipalities-map.json")
CreateFolder(Folder="${MapFolder}/layers",CreateParentFolders="True",IfFolderExists="Ignore")
# ---------
# Map
CopyFile(SourceFile="municipalities-map.json",DestinationFile="${MapFolder}/municipalities-map.json")
CopyFile(SourceFile="municipalities-map.md",DestinationFile="${MapFolder}/municipalities-map.md")
# ---------
# Layers
CopyFile(SourceFile="layers/municipal-boundaries.geojson",DestinationFile="${MapFolder}/layers/municipal-boundaries.geojson")
CopyFile(SourceFile="layers/municipal-boundaries.md",DestinationFile="${MapFolder}/layers/municipal-boundaries.md")
CopyFile(SourceFile="layers/municipal-boundaries-event-config.json",DestinationFile="${MapFolder}/layers/municipal-boundaries-event-config.json")
#
CopyFile(SourceFile="layers/municipalities.geojson",DestinationFile="${MapFolder}/layers/municipalities.geojson")
CopyFile(SourceFile="layers/municipalities.md",DestinationFile="${MapFolder}/layers/municipalities.md")
CopyFile(SourceFile="layers/municipalities-event-config.json",DestinationFile="${MapFolder}/layers/municipalities-event-config.json")
# -------
# Graphs
CreateFolder(Folder="${MapFolder}/graphs",CreateParentFolders="True",IfFolderExists="Ignore")
CopyFile(SourceFile="graphs/municipality-population-graph-config.json",DestinationFile="${MapFolder}/graphs/municipality-population-graph-config.json")
