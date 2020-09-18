#!/bin/sh

# Copy  files to 'infomapper/src/assets/app' folder.
# Brute force way to provide content to InfoMapper and version control.
# Folder for this script is similar to:
#   /c/Users/user/owf-dev/Project-Muni-Ag-FrontRange/git-repos/owf-app-ag-urban-workflow/web

# Supporting functions, alphabetized.

checkHistoricalSimulationFolder() {
  # Make sure that the receiving folder exists
  folder=${appFolder}/data-maps/HistoricalSimulation
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

copyIrrigatedLands() {
  checkSupportingDataFolder

  # Copy stream reaches map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Agriculture-IrrigatedLands ${folder}
}

copyMunicipalities() {
  checkSupportingDataFolder

  # Copy municipalities map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Municipal-Municipalities ${folder}
}

copyMunicipalRentals() {
  checkSupportingDataFolder

  # Copy municipal water rentals map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Municipal-WaterRentals ${folder}
}

copyWaterTransferCaseStudies() {
  checkSupportingDataFolder

  # Copy transfer case studies map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/WaterTransfer-CaseStudies ${folder}
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

copyStreamReaches() {
  checkSupportingDataFolder

  # Copy stream reaches map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Physical-StreamReaches ${folder}
}

copyWaterDistricts() {
  checkSupportingDataFolder

  # Copy water districts map folder and files
  cp -rv ${scriptFolder}/data-maps/SupportingData/Administration-CoDwrWaterDistricts ${folder}
}

runInteractive() {
  while true; do
    echo ""
    echo "Enter an option to update application data."
    echo ""
    echo " c.  Copy main configuration files."
    echo "sw.  Copy SupportingData/Administration - CoDwrWaterDistricts map files."
    echo "ss.  Copy SupportingData/Physical - StreamReaches map files."
    echo "sl.  Copy SupportingData/Agriculture - IrrigatedLands map files."
    echo "sm.  Copy SupportingData/Municipal - Municipalities map files."
    echo "smr. Copy SupportingData/Municipal - Water Rentals map files."
    echo "stc. Copy SupportingData/WaterTransfer - Case Studies map files."
    echo ""
    echo "h.   Copy HistoricalSimulation/cm2015H2 map files."
    echo ""
    echo "q.  Quit"
    echo ""
    read -p "Enter command: " answer
    # The following are in the order above
    if [ "${answer}" = "c" ]; then
      copyMainConfig

    elif [ "${answer}" = "sw" ]; then
      copyWaterDistricts
    elif [ "${answer}" = "ss" ]; then
      copyStreamReaches
    elif [ "${answer}" = "sl" ]; then
      copyIrrigatedLands
    elif [ "${answer}" = "sm" ]; then
      copyMunicipalities
    elif [ "${answer}" = "smr" ]; then
      copyMunicipalRentals
    elif [ "${answer}" = "stc" ]; then
      copyWaterTransferCaseStudies

    elif [ "${answer}" = "h" ]; then
      copyCm2015H2

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
