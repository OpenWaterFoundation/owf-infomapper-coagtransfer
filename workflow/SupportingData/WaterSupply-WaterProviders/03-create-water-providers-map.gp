# Create a GeoMapProject file for water providers
# - read the previously downloaded layer file
# - output to the web folder for use by the InfoMapper
# - layer view groups are added from 1st drawn (bottom) to last drawn (top)
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/SupportingData/WaterSupply-WaterProviders")
SetProperty(PropertyName="WWRRepoFolder",PropertyType="str",PropertyValue="../../../../owf-infomapper-coagtransfer-data-wwr")
#
# Create a single map project and map for that project.
# - GeoMapProjectID:  WaterProvidersProject
# - GeoMapID:  WaterProvidersMap
CreateGeoMapProject(NewGeoMapProjectID="WaterProvidersProject",ProjectType="SingleMap",Name="Colorado Water Providers",Description="Colorado Water Providers",Properties="author:'Open Water Foundation',specificationFlavor:'',specificationVersion:'1.0.0'")
CreateGeoMap(NewGeoMapID="WaterProvidersMap",Name="Colorado Water Providers",Description="Colorado Water Providers",CRS="EPSG:4326",Properties="extentInitial:'ZoomLevel:-107.473,39.106,7.5',docPath:'water-providers-map.md'")
AddGeoMapToGeoMapProject(GeoMapProjectID="WaterProvidersProject",GeoMapID="WaterProvidersMap")
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
# Water providers raster data:  read layers and add to a layer view group.
# - copy from the repository that contains WWR data
# GeoLayerViewGroupID: WaterProvidersRasterGroup
#
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="WaterProvidersRasterGroup",Name="Colorado Water Providers (Raster)",Description="Colorado water providers area derived from polygons",InsertPosition="Top")
#
CopyFile(SourceFile="${WWRRepoFolder}/Rasters/WaterProviders.tif",DestinationFile="layers/WaterProviders.tif")
CopyFile(SourceFile="${WWRRepoFolder}/Rasters/WaterProviders.csv",DestinationFile="layers/WaterProviders.csv")
ReadRasterGeoLayerFromFile(InputFile="layers/WaterProviders.tif",GeoLayerID="WaterProvidersRasterLayer",Name="Colorado Water Providers (Raster)",Description="Colorado Water Providers area derived from polygons")
AddGeoLayerViewToGeoMap(GeoLayerID="WaterProvidersRasterLayer",GeoLayerViewID="WaterProvidersRasterLayerView",Name="Colorado Water Providers (Raster)",Description="Colorado Water Providers area derived from polygons",Properties="docPath:'layers/WaterProviders.md'")
# Use category colors
#SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="WaterProvidersRasterLayerView",Name="Colorize Water Providers",Description="Symbol for the water providers raster",ClassificationAttribute="DIV",Properties="classificationFile:'layers/co-dwr-water-divisions-classify-division.csv'")
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="WaterProvidersRasterLayerView",Name="Colorize Water Providers",Description="Symbol for the water providers raster",ClassificationAttribute="1",Properties="classificationFile:'layers/WaterProviders-classify-waterprovider.csv'")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProvidersRasterLayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/WaterProviders-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProvidersRasterLayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/WaterProviders-event-config.json")
# = = = = = = = = = =
# Colorado state boundary:  read layer and add to layer view group.
# StateBoundaryGroupID: StateBoundaryGroup
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="StateBoundaryGroup",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE.",Properties="selectedInitial: true",InsertPosition="Top")
#
ReadGeoLayerFromGeoJSON(InputFile="https://opendata.arcgis.com/datasets/4402a8e032ed49eb8b37fd729e4e8f03_9.geojson",GeoLayerID="StateBoundaryLayer",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE.")
AddGeoLayerViewToGeoMap(GeoLayerID="StateBoundaryLayer",GeoLayerViewID="StateBoundaryLayerView",Name="Colorado State Boundary",Description="Colorado state boundary from CDPHE",InsertPosition="Top")
SetGeoLayerViewSingleSymbol(GeoLayerViewID="StateBoundaryLayerView",Name="State boundary symbol",Description="State boundary in black.",Properties="color:#000000,fillColor:#000000,fillOpacity:0.0,weight:2")
# = = = = = = = = = =
# Denver Water boundaries:  read layer and add to a layer view group.
# GeoLayerViewGroupID: WaterProvidersGroup
#
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="WaterProvidersGroup",Name="Colorado Water Providers",Description="Colorado Water Providers",InsertPosition="Top")
#
ReadGeoLayerFromGeoJSON(InputFile="layers/denver-water-boundary.geojson",GeoLayerID="DenverWaterBoundaryLayer",Name="Denver Water Boundary",Description="Denver Water Boundary from Denver Water")
AddGeoLayerViewToGeoMap(GeoLayerID="DenverWaterBoundaryLayer",GeoLayerViewID="DenverWaterBoundaryLayerView",Name="Denver Water Boundary",Description="Denver Water Boundary",InsertPosition="Top",Properties="docPath:'layers/denver-water-boundary.md'")
# For now use single symbol
# - grey
SetGeoLayerViewSingleSymbol(GeoLayerViewID="DenverWaterBoundaryLayerView",Name="Denver Water Boundary",Description="Denver Water Boundary",Properties="color:#cc7a00,opacity:1.0,fillColor:#cc7a00,fillOpacity:0.3,weight:2")
SetGeoLayerViewEventHandler(GeoLayerViewID="DenverWaterBoundaryLayerView",EventType="click",Properties="eventConfigPath:layers/denver-water-boundary-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="DenverWaterBoundaryLayerView",EventType="hover",Properties="eventConfigPath:layers/denver-water-boundary-event-config.json")
# = = = = = = = = = =
# Water Provider boundaries:  read layer and add to a layer view group.
# GeoLayerViewGroupID: WaterProvidersGroup
#
ReadGeoLayerFromGeoJSON(InputFile="layers/water-provider-boundaries.geojson",GeoLayerID="WaterProviderBoundariesLayer",Name="Colorado Water Provider Boundaries",Description="Colorado Water Provider Boundaries")
AddGeoLayerViewToGeoMap(GeoLayerID="WaterProviderBoundariesLayer",GeoLayerViewID="WaterProviderBoundariesLayerView",Name="Water Provider Boundaries (Districts)",Description="Water Provider Boundaries from DOLA special and metro districts",InsertPosition="Top",Properties="docPath:'layers/water-provider-boundaries.md'")
# For now use single symbol
# - grey
SetGeoLayerViewSingleSymbol(GeoLayerViewID="WaterProviderBoundariesLayerView",Name="Colorado Water Provider Boundaries",Description="Colorado Water Provider Boundaries",Properties="color:#595959,opacity:1.0,fillColor:#595959,fillOpacity:0.3,weight:2")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProviderBoundariesLayerView",EventType="click",Properties="eventConfigPath:layers/water-provider-boundaries-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProviderBoundariesLayerView",EventType="hover",Properties="eventConfigPath:layers/water-provider-boundaries-event-config.json")
# = = = = = = = = = =
# Water provider points:  read layer and add to a layer view group.
# GeoLayerViewGroupID: WaterProvidersGroup
ReadGeoLayerFromGeoJSON(InputFile="layers/water-providers.geojson",GeoLayerID="WaterProvidersLayer",Name="Colorado Water Providers",Description="Colorado Water Providers")
AddGeoLayerViewToGeoMap(GeoLayerID="WaterProvidersLayer",GeoLayerViewID="WaterProvidersLayerView",Name="Colorado Water Providers",Description="Colorado Water Providers",InsertPosition="Top",Properties="docPath:'layers/water-providers.md'")
# For now use single symbol
# - TODO smalers 2020-05-22 need to enable a graduated symbol based on flow value
SetGeoLayerViewSingleSymbol(GeoLayerViewID="WaterProvidersLayerView",Name="Colorado Water Providers",Description="Colorado Water Providers",Properties="symbolImage:/img/drinkingwater-32x37.png,imageAnchorPoint:Bottom")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProvidersLayerView",EventType="hover",Name="Hover event",Description="Hover event configuration",Properties="eventConfigPath:layers/water-providers-event-config.json")
SetGeoLayerViewEventHandler(GeoLayerViewID="WaterProvidersLayerView",EventType="click",Name="Click event",Description="Click event configuration",Properties="eventConfigPath:layers/water-providers-event-config.json")
# = = = = = = = = = =
# Write the map project file and copy layers to the location needed by the web application.
# - follow InfoMapper conventions
WriteGeoMapProjectToJSON(GeoMapProjectID="WaterProvidersProject",Indent="2",OutputFile="water-providers-map.json")
CreateFolder(Folder="${MapFolder}/layers",CreateParentFolders="True",IfFolderExists="Ignore")
CopyFile(SourceFile="water-providers-map.json",DestinationFile="${MapFolder}/water-providers-map.json")
CopyFile(SourceFile="water-providers-map.md",DestinationFile="${MapFolder}/water-providers-map.md")
# Rasters
CopyFile(SourceFile="layers/WaterProviders.tif",DestinationFile="${MapFolder}/layers/WaterProviders.tif")
CopyFile(SourceFile="layers/WaterProviders.csv",DestinationFile="${MapFolder}/layers/WaterProviders.csv")
CopyFile(SourceFile="layers/WaterProviders.md",DestinationFile="${MapFolder}/layers/WaterProviders.md")
CopyFile(SourceFile="layers/WaterProviders-classify-waterprovider.csv",DestinationFile="${MapFolder}/layers/WaterProviders-classify-waterprovider.csv")
CopyFile(SourceFile="layers/WaterProviders-event-config.json",DestinationFile="${MapFolder}/layers/WaterProviders-event-config.json")
#
CopyFile(SourceFile="layers/denver-water-boundary.geojson",DestinationFile="${MapFolder}/layers/denver-water-boundary.geojson")
CopyFile(SourceFile="layers/denver-water-boundary.md",DestinationFile="${MapFolder}/layers/denver-water-boundary.md")
CopyFile(SourceFile="layers/denver-water-boundary-event-config.json",DestinationFile="${MapFolder}/layers/denver-water-boundary-event-config.json")
#
CopyFile(SourceFile="layers/water-provider-boundaries.geojson",DestinationFile="${MapFolder}/layers/water-provider-boundaries.geojson")
CopyFile(SourceFile="layers/water-provider-boundaries.md",DestinationFile="${MapFolder}/layers/water-provider-boundaries.md")
CopyFile(SourceFile="layers/water-provider-boundaries-event-config.json",DestinationFile="${MapFolder}/layers/water-provider-boundaries-event-config.json")
#
CopyFile(SourceFile="layers/water-providers.geojson",DestinationFile="${MapFolder}/layers/water-providers.geojson")
CopyFile(SourceFile="layers/water-providers.md",DestinationFile="${MapFolder}/layers/water-providers.md")
CopyFile(SourceFile="layers/water-providers-event-config.json",DestinationFile="${MapFolder}/layers/water-providers-event-config.json")
