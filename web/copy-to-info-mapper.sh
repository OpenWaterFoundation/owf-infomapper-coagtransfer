
# Copy  files to 'infomapper/src/assets/app' folder.
# Brute force way to provide content to InfoMapper and version control.
# Folder for this script is similar to:
#   /c/Users/user/owf-dev/Project-Muni-Ag-FrontRange/git-repos/owf-app-ag-urban-workflow/web

# Supporting functions, alphabetized.

checkBaselineScenarioFolder() {
  # Make sure that the receiving folder exists
  folder=${appFolder}/data-maps/BaselineScenario
  if [ ! -d "${folder}" ]; then
    echo "Creating folder ${folder}"
    mkdir -p ${folder}
  fi
}

checkScenario1Folder() {
  # Make sure that the receiving folder exists
  folder=${appFolder}/data-maps/Scenario1
  if [ ! -d "${folder}" ]; then
    echo "Creating folder ${folder}"
    mkdir -p ${folder}
  fi
}

checkSupportingDataFolder() {
  # Make sure that the receiving folder exists
  folder=${appFolder}/data-maps/SupportingData
  if [ ! -d "${folder}" ]; then
    echo "Creating folder ${folder}"
    mkdir -p ${folder}
  fi
}

copyBaselineScenario_CountyPopulation() {
  checkBaselineScenarioFolder

  # Copy counties map folder and files
  cp -rv ${scriptFolder}/data-maps/BaselineScenario/02a-CountyPopulation ${folder}
}

copyBaselineScenario_LandDevelopment() {
  checkBaselineScenarioFolder

  # Copy counties map folder and files
  cp -rv ${scriptFolder}/data-maps/BaselineScenario/13-LandDevelopment ${folder}
}

copyBaselineScenario_MunicipalityPopulation() {
  checkBaselineScenarioFolder

  # Copy counties map folder and files
  cp -rv ${scriptFolder}/data-maps/BaselineScenario/02b-MunicipalityPopulation ${folder}
}

copyBaselineScenario_Synopsis() {
  checkBaselineScenarioFolder

  # Copy synopsis files
  cp -rv ${scriptFolder}/data-maps/BaselineScenario/00-Synopsis ${folder}
}

copyMainConfig() {
  # Make sure that folders exist
  if [ ! -d "${appFolder}" ]; then
    echo "Creating folder ${appFolder}"
    mkdir -p ${appFolder}
  fi

  # Main application configuration file
  cp -v ${scriptFolder}/app-config.json ${appFolder}
  # Content pages
  cp -rv ${scriptFolder}/content-pages ${appFolder}
  # Images
  cp -rv ${scriptFolder}/img ${appFolder}
}

copyScenario1Scenario_Synopsis() {
  checkScenario1Folder

  # Copy synopsis files
  cp -rv ${scriptFolder}/data-maps/Scenario1/00-Synopsis ${folder}
}

copySupportingData_CoDwrWaterDistricts() {
  checkSupportingDataFolder

  # Copy water districts map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Administration-CoDwrWaterDistricts ${folder}
}

copySupportingData_Counties() {
  checkSupportingDataFolder

  # Copy counties map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Political-Counties ${folder}
}

copySupportingData_IrrigatedLands() {
  checkSupportingDataFolder

  # Copy irrigated lands map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Agriculture-IrrigatedLands ${folder}
}

copySupportingData_IrrigatedLandsRaster() {
  checkSupportingDataFolder

  # Copy irrigated lands (raster) map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Agriculture-IrrigatedLandsRaster ${folder}
}

copySupportingData_Municipalities() {
  checkSupportingDataFolder

  # Copy municipalities map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Municipal-Municipalities ${folder}
}

copySupportingData_MunicipalRentals() {
  checkSupportingDataFolder

  # Copy municipal water rentals map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Municipal-WaterRentals ${folder}
}

copySupportingData_MunicipalDedicationPolicies() {
  checkSupportingDataFolder

  # Copy municipal water dedication policies map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Municipal-WaterDedicationPolicies ${folder}
}

copySupportingData_StreamReaches() {
  checkSupportingDataFolder

  # Copy stream reaches map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Physical-StreamReaches ${folder}
}

copySupportingData_Synopsis() {
  checkSupportingDataFolder

  # Copy synopsis files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Synopsis ${folder}
}

copySupportingData_WaterProviders() {
  checkSupportingDataFolder

  # Copy water providers map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/WaterSupply-WaterProviders ${folder}
}

copySupportingData_WaterTransferCaseStudies() {
  checkSupportingDataFolder

  # Copy transfer case studies map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/WaterTransfer-CaseStudies ${folder}
}

runInteractive() {
  while true; do
    echo ""
    echo "Enter an option to update application data."
    echo ""
    echo "    c. Copy main configuration files."
    echo " ssyn. Copy SupportingData/Synopsis files."
    echo "   sw. Copy SupportingData/Administration - CoDwrWaterDistricts map files."
    echo "   sc. Copy SupportingData/Political - Counties map files and time series."
    #echo "   ss. Copy SupportingData/Physical - StreamReaches map files."
    echo "  slr. Copy SupportingData/Agriculture - IrrigatedLands (Raster) map files."
    echo "   sl. Copy SupportingData/Agriculture - IrrigatedLands map files."
    echo "   sm. Copy SupportingData/Municipal - Municipalities map files and time series."
    echo "  swp. Copy SupportingData/WaterSupply - Water Providers map files."
    echo "       ----"
    echo "  smd. Copy SupportingData/Municipal - Water Dedication Policies map files."
    echo "  smr. Copy SupportingData/Municipal - Water Rentals map files."
    echo "  stc. Copy SupportingData/WaterTransfer - Case Studies map files."
    echo ""
    echo "   bs.    Copy BaselineScenario/Synopsis map files."
    echo "   bc. 2a Copy BaselineScenario/CountyPopulation map files."
    echo "   bm. 2b Copy BaselineScenario/MunicipalityPopulation map files."
    echo "  bld. 13 Copy BaselineScenario/LandDevelopment map files."
    echo ""
    echo "   1s. Copy Scenario1/Synopsis map files."
    echo ""
    echo "    q. Quit"
    echo ""
    read -p "Enter command: " answer
    # The following are in the order above
    if [ "${answer}" = "c" ]; then
      copyMainConfig

    elif [ "${answer}" = "ssyn" ]; then
      copySupportingData_Synopsis
    elif [ "${answer}" = "sw" ]; then
      copySupportingData_CoDwrWaterDistricts
    elif [ "${answer}" = "sc" ]; then
      copySupportingData_Counties
    #elif [ "${answer}" = "ss" ]; then
      #copySupportingData_StreamReaches
    elif [ "${answer}" = "slr" ]; then
      copySupportingData_IrrigatedLandsRaster
    elif [ "${answer}" = "sl" ]; then
      copySupportingData_IrrigatedLands
    elif [ "${answer}" = "sm" ]; then
      copySupportingData_Municipalities
    elif [ "${answer}" = "smd" ]; then
      copySupportingData_MunicipalDedicationPolicies
    elif [ "${answer}" = "smr" ]; then
      copySupportingData_MunicipalRentals
    elif [ "${answer}" = "swp" ]; then
      copySupportingData_WaterProviders
    elif [ "${answer}" = "stc" ]; then
      copySupportingData_WaterTransferCaseStudies

    # Baseline scenario

    elif [ "${answer}" = "bs" ]; then
      copyBaselineScenario_Synopsis
    elif [ "${answer}" = "bc" ]; then
      copyBaselineScenario_CountyPopulation
    elif [ "${answer}" = "bm" ]; then
      copyBaselineScenario_MunicipalityPopulation
    elif [ "${answer}" = "bld" ]; then
      copyBaselineScenario_LandDevelopment

    # Scenario1 scenario

    elif [ "${answer}" = "1s" ]; then
      copyScenario1Scenario_Synopsis

    elif [ "${answer}" = "q" ]; then
      break
    fi
  done
  return 0
}

# Entry point into script.

scriptFolder=$(cd $(dirname "$0") && pwd)
repoFolder=$(dirname $scriptFolder)
gitReposFolder=$(dirname $repoFolder)
infoMapperRepoFolder=${gitReposFolder}/owf-app-infomapper-ng
infoMapperFolder=${infoMapperRepoFolder}/infomapper
appFolder=${infoMapperFolder}/src/assets/app

echo "Folders for application:"
echo "scriptFolder=${scriptFolder}"
echo "repoFolder=${repoFolder}"
echo "gitReposFolder=${gitReposFolder}"
echo "infoMapperRepoFolder=${infoMapperRepoFolder}"
echo "infoMapperFolder=${infoMapperRepoFolder}"
echo "appFolder=${appFolder}"

# Run interactively. with script exit from that function
runInteractive
