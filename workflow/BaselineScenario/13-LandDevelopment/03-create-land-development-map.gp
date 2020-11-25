# Create a GeoMapProject file for land development
# - read the previously downloaded layer file
# - output to the web folder for use by the InfoMapper
# - layer view groups are added from 1st drawn (bottom) to last drawn (top)
#
# Define properties to control processing.
# - use relative paths so that the command file is portable
# - AssetsFolder is where map files exist for the InfoMapper tool
SetProperty(PropertyName="AppFolder",PropertyType="str",PropertyValue="../../../web")
SetProperty(PropertyName="MapsFolder",PropertyType="str",PropertyValue="${AppFolder}/data-maps")
SetProperty(PropertyName="MapFolder",PropertyType="str",PropertyValue="${MapsFolder}/BaselineScenario/13-LandDevelopment")
#SetProperty(PropertyName="WWRRepoFolder",PropertyType="str",PropertyValue="../../../../owf-infomapper-coagtransfer-data-wwr")
SetProperty(PropertyName="AnalysisFolder",PropertyType="str",PropertyValue="../../../workflow-v1/data-processing/11-Map-LandDevelopment")
#
# Create a single map project and map for that project.
# - GeoMapProjectID:  MunicipalLandDevelopmentProject
# - GeoMapID:  MunicipalitiesMap
CreateGeoMapProject(NewGeoMapProjectID="MunicipalLandDevelopmentProject",ProjectType="SingleMap",Name="Colorado Municipalities",Description="Colorado Municipalities",Properties="author:'Open Water Foundation',specificationFlavor:'',specificationVersion:'1.0.0'")
CreateGeoMap(NewGeoMapID="MunicipalitiesMap",Name="Colorado Municipalities",Description="Colorado Municipalities",CRS="EPSG:4326",Properties="extentInitial:'ZoomLevel:-107.473,39.106,7.5',docPath:'municipalities-map.md'")
AddGeoMapToGeoMapProject(GeoMapProjectID="MunicipalLandDevelopmentProject",GeoMapID="MunicipalitiesMap")
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
SetGeoLayerViewSingleSymbol(GeoLayerViewID="StateBoundaryLayerView",Name="State boundary symbol",Description="State boundary in black.",Properties="color:#000000,opacity:1.0,fillColor:#000000,fillOpacity:0.0,weight:2")
# = = = = = = = = = =
# Municipal growth raster data:  read layers and add to a layer view group.
# - copy from the repository that contains WWR data
# GeoLayerViewGroupID: MunicipalLandDevelopmentGroup
#
AddGeoLayerViewGroupToGeoMap(GeoLayerViewGroupID="MunicipalLandDevelopmentGroup",Name="Municipal Land Development (Raster)",Description="Municipal Land Development",InsertPosition="Top",Properties="selectBehavior:Single")
#
# Low
ReadRasterGeoLayerFromFile(InputFile="layers/Low_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",Name="Municipal Land Development - Low Density (Raster)",Description="Municipal land development, low density (estimate by year)")
AddGeoLayerViewToGeoMap(GeoLayerID="MunicipalLandDevelopmentLowDensityRasterLayer",GeoLayerViewID="MunicipalLandDevelopmentLowDensityRasterLayerView",Name="Municipal Land Development - Low Density (Raster)",Description="Municipal land development, low density (estimate by year)",Properties="docPath:'layers/Municipal_Growth.md'")
# Use category colors
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="MunicipalLandDevelopmentLowDensityRasterLayerView",Name="Colorize municipal land development",Description="Symbol for the municipal land development raster",ClassificationAttribute="1",Properties="classificationFile:'layers/Municipal_Growth-classify-year.csv'")
# Medium
ReadRasterGeoLayerFromFile(InputFile="layers/Medium_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentMediumDensityRastherLayer",Name="Municipal Land Development - Medium Density (Raster)",Description="Municipal land development, medium density (estimate by year)")
AddGeoLayerViewToGeoMap(GeoLayerID="MunicipalLandDevelopmentMediumDensityRastherLayer",GeoLayerViewID="MunicipalLandDevelopmentMediumDensityRastherLayerView",Name="Municipal Land Development - Medium Density (Raster)",Description="Municipal land development, medium density (estimate by year)",Properties="docPath:'layers/Municipal_Growth.md'")
# Use category colors
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="MunicipalLandDevelopmentMediumDensityRastherLayerView",Name="Colorize municipal land development",Description="Symbol for the municipal land development raster",ClassificationAttribute="1",Properties="classificationFile:'layers/Municipal_Growth-classify-year.csv'")
# High
ReadRasterGeoLayerFromFile(InputFile="layers/High_Density_Municipal_Growth.tif",GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",Name="Municipal Land Development - High Density (Raster)",Description="Municipal land development, high density (estimate by year)")
AddGeoLayerViewToGeoMap(GeoLayerID="MunicipalLandDevelopmentHighDensityRasterLayer",GeoLayerViewID="MunicipalLandDevelopmentHighDensityRasterLayerView",Name="Municipal Land Development - High Density (Raster)",Description="Municipal land development, high density (estimate by year)",Properties="docPath:'layers/Municipal_Growth.md'")
# Use category colors
SetGeoLayerViewCategorizedSymbol(GeoLayerViewID="MunicipalLandDevelopmentHighDensityRasterLayerView",Name="Colorize municipal land development",Description="Symbol for the municipal land development raster",ClassificationAttribute="1",Properties="classificationFile:'layers/Municipal_Growth-classify-year.csv'")
# = = = = = = = = = =
# Write the map project file and copy layers to the location needed by the web application.
# - follow InfoMapper conventions
WriteGeoMapProjectToJSON(GeoMapProjectID="MunicipalLandDevelopmentProject",Indent="2",OutputFile="land-development-map.json")
CreateFolder(Folder="${MapFolder}/layers",CreateParentFolders="True",IfFolderExists="Ignore")
# ---------
# Map
CopyFile(SourceFile="land-development-map.json",DestinationFile="${MapFolder}/land-development-map.json")
CopyFile(SourceFile="land-development-map.md",DestinationFile="${MapFolder}/land-development-map.md")
# ---------
# Rasters
CopyFile(SourceFile="layers/Low_Density_Municipal_Growth.tif",DestinationFile="${MapFolder}/layers/Low_Density_Municipal_Growth.tif")
CopyFile(SourceFile="layers/Medium_Density_Municipal_Growth.tif",DestinationFile="${MapFolder}/layers/Medium_Density_Municipal_Growth.tif")
CopyFile(SourceFile="layers/High_Density_Municipal_Growth.tif",DestinationFile="${MapFolder}/layers/High_Density_Municipal_Growth.tif")
CopyFile(SourceFile="layers/Municipal_Growth-classify-year.csv",DestinationFile="${MapFolder}/layers/Municipal_Growth-classify-year.csv")
CopyFile(SourceFile="layers/Municipal_Growth.md",DestinationFile="${MapFolder}/layers/Municipal_Growth.md")
