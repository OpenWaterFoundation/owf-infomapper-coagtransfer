# Download county population data from CO Department of Local Affairs (DOLA)
# - this should only need to be done periodically (once per year)
# - data are usually updated in October
#
# The following are historical population estimates (csv file)
WebGet(URL="https://storage.googleapis.com/co-publicdata/county-muni-timeseries.csv",OutputFile="downloads/county-muni-population-timeseries-dola.csv",Timeout="10")
#
# The following are population forecasts (Excel xls workbook)
WebGet(URL="https://drive.google.com/uc?export=download&id=0B-vz6H4k4SESdkNHSng2VGlEc1k",OutputFile="downloads/county-population-forecast-dola.xls",Timeout="10")
