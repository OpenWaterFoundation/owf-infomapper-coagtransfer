# Download county population data from CO Department of Local Affairs (DOLA)
# - this should only need to be done periodically (once per year)
# - data are usually updated in October
#
# The following are historical population estimates (csv file)
# - see page:  https://demography.dola.colorado.gov/population/
# - then press "Get Data"
# - then on page:  https://demography.dola.colorado.gov/population/data/
# - then use "OR download" link for "county-muni-timeseries.csv"
WebGet(URL="https://storage.googleapis.com/co-publicdata/county-muni-timeseries.csv",OutputFile="downloads/county-muni-population-timeseries-dola.csv",Timeout="10")
#
# The following are population forecasts (Excel xls workbook)
# - see page:  https://demography.dola.colorado.gov/population/population-totals-counties/#population-totals-for-colorado-counties
# - see the "Popoulation Forecasts- years (2000 to 2050)" section
# - then use "1 year increments, 2000 - 2050" link
# - the "Get Data" link on this page goes to the page with historical data for the download above
WebGet(URL="https://drive.google.com/uc?export=download&id=0B-vz6H4k4SESdkNHSng2VGlEc1k",OutputFile="downloads/county-population-forecast-dola.xls",Timeout="10")
