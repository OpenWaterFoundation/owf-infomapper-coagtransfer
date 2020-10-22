# Download county list from Open Water Foundation
# - this should only need to be done periodically
# - this dataset provides additional properties for counties
WebGet(URL="https://raw.githubusercontent.com/OpenWaterFoundation/owf-data-co-counties/master/data/Colorado-Counties.csv",OutputFile="downloads/county-data-owf.csv",Timeout="10")
