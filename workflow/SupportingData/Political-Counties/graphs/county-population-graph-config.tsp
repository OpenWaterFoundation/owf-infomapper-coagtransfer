# This product is used to generate the template JSON file.
# Use Larimer county for example.
# The word 'Larimer' will be replaced in the JSON template so that it
# can be usd for all counties by the InfoMapper.

[Product]

ProductType = "Graph"
TotalWidth = "600"
TotalHeight = "400"
MainTitleString = "Larimer County Total Population"
SubTitleString = "Source:  DOLA"

[SubProduct 1]

GraphType = "Line"
LeftYAxisTitlePosition = "LeftOfAxis"
LeftYAxisTitleRotation = "270"
LeftYAxisTitleString = "Total Population"
RightYAxisGraphType = "None"
RightYAxisIgnoreUnits = "false"
LayoutYPercent = ""

[Data 1.1]

Color = "0x0000ff"
GraphType = "Line"
TSID = "County:Larimer.DOLA.Population-Total.Year"
LineWidth = 2
TSAlias = "Larimer-County-Population-Total"

[Data 1.2]

GraphType = "Point"
TSID = "County:Larimer.DOLA.Population-Forecast.Year"
TSAlias = "Larimer-County-Population-Forecast"
Color = "0xff0000"
SymbolSize = "5"
SymbolStyle = "Circle-Filled"

[Data 1.3]

Color = "0x000000"
GraphType = "Line"
LineWidth = 2
TSID = "County:Larimer.DOLA.Population-Muni.Year"
TSAlias = "Larimer-County-Population-Muni"

[Data 1.4]

Color = "0x00ff00"
GraphType = "Line"
LineWidth = 2
TSID = "County:Larimer.DOLA.Population-Unincorp.Year"
TSAlias = "Larimer-County-Population-Unincorp"
