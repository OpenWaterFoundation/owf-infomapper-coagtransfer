[Product]

ProductType = "Graph"
TotalWidth = "600"
TotalHeight = "400"
MainTitleString = "Swink Municipality Total Population (Baseline)"
SubTitleString = "Source:  DOLA, Model"

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
LineWidth = 2
TSID = "Muni:Swink.Model.Population-Total.Year.Baseline"
TSAlias = "Swink-Muni-Population-Total-Baseline"

[Data 1.2]

GraphType = "Point"
Color = "0xff0000"
SymbolSize = 5
SymbolStyle = "Circle-Filled"
TSID = "Muni:Swink.Model.Population-Forecast.Year.Baseline"
TSAlias = "Swink-Muni-Population-Forecast-Baseline"
