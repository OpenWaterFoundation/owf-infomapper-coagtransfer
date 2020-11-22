# owf-infomapper-coagtransfer

This repository contains the InfoMapper implementation for
the Colorado Agriculture Water Transfer website.
The OWF InfoMapper web application provides access to maps, graphs, and other information products.
See also:

* [Deployed website](http://coagtransfer.openwaterfoundation.org/latest/)
* [owf-app-infomapper-ng](https://github.com/OpenWaterFoundation/owf-app-infomapper-ng)
repository for the general InfoMapper web application code.

The following sections are included in this documentation:

* [Overview](#overview)
* [Repository Contents](#repository-contents)
* [Application Menus and Corresponding Workflow](#application-menus-and-corresponding-workflow)
* [Development Environment](#development-environment)
	+ [Quick Start](#quick-start)
	+ [Development Tools](#development-tools)
	+ [InfoMapper Configuration](#infomapper-configuration)
* [Maintainers](#maintainers)

--------------

## Overview ##

This repository implements analysis and visualization to create a municipal water demand and agricultural water transfer dashboard.
The project is explained in the website [home page](web/content-pages/home.md).
There are two primary objectives in the creation of a municipal water demand and agricultural water transfer dashboard:

1. Automate input data processing and analysis steps so that the analysis is repeatable, updatable, and transparent.
2. Publish the data input and results of the municipal water balance analysis to an online dashboard.

The original WestWater Research analysis tool consisted of Excel workbooks containing data such as population data,
municipal land area growth, current firm supply, total and future water supply,
total and future water demand, and projected shortages.
Data preparation and WWR analysis were performed in a largely manual fashion.
The input data for the WWR analysis focused on data at a 10-year interval.
However, many input datasets, such as population forecast data, are available on an annual basis or can be estimated as annual values.
OWF updated the analysis to use annual data to the year 2050.
The use of annual data provides more consistency, flexibility, and scalability of the analysis.
Details about the analysis are provided in `README.md` files and information Markdown files for map and other analysis products.

## Repository Contents ##

The following folder structure is recommended for development.
Top-level folders should be created as necessary.
The following folder structure clearly separates user files (as per operating system),
development area (`owf-dev`), product (`InfoMapper-COAgTransfer`), repositories for product (`git-repos`),
and specific repositories for the product.
Repository folder names should agree with GitHub repository names.
Scripts in repository folders that process data should detect their starting location
and then locate other folders based on the following convention.

```
C:\Users\user\                                 User's home folder for Windows.
/c/Users/user/                                 User's home folder for Git Bash.
/cygdrive/C/Users/user/                        User's home folder for Cygwin.
/home/user/                                    User's home folder for Linux.
  owf-dev/                                     Work done on Open Water Foundation projects.
    InfoMapper-COAgTransfer/                   Colorado Agricultural Water Transfer website, using InfoMapper
                                               (name of this folder is recommended).
      ---- below here folder names should match exactly ----
      git-repos/                               Git repositories for the web application.
        owf-app-infomapper-ng/                 InfoMapper web application.
        owf-infomapper-coagtransfer/           Workflow files to process input for web application.
        owf-infomapper-coagtransfer-data-wwr/  Data from WestWater Research (private repository).
```

This repository contains the following:

```
owf-infomapper-coagtransfer/           Workflow files to process input for web application.
  .git/                                Standard Git software folder for repository (DO NOT TOUCH).
  .gitattributes/                      Standard Git configuration file for repository (for portability).
  .gitignore/                          Standard Git configuration file to ignore dynamic working files.
  build-util/                          Scripts to manage repository, as needed.
    copy-to-owf-amazon-s3.sh           Copy the web application to OWF's Amazon S3 bucket.
    git-check-prod.sh                  Check whether need to push/pull any product repositories.
  web/                                 Location of assembled website files created by workflow steps.
                                       Will be copied to InfoMapper 'assets/app' folder.
  workflow/                            Command files and scripts to download and process data into maps
                                       and perform analysis steps.  Folders match menu organization.
```

## Application Menus and Corresponding Workflow ##

The web application provides menus that display maps, as follows.
The README for each map provides information about data sources and workflow processing from developer perspective.
The Info for each map provides information from web application user perspective.

| **Menu** | **README** | **Info** |
| -- | -- | -- |
| ***Supporting Data /*** | ===========| ===============================|
| ***Administration - CO DWR Water Districts*** | [README](workflow/SupportingData/Administration-CoDwrWaterDistricts/README.md) | [Info](workflow/SupportingData/Administration-CoDwrWaterDistricts/codwr-waterdistricts-map.md) |
| ***Political - Counties*** | [README](workflow/SupportingData/Political-Counties/README.md) | [Info](workflow/SupportingData/Political-Counties/counties-map.md) |
| ***Physical - Stream Reaches*** | | Currently not enabled. |
| ***Agriculture - Ditches*** | | Currently not enabled. |
| ***Agriculture - Irrigated Lands (Raster)*** | [README](workflow/SupportingData/Agriculture-IrrigatedLandsRaster/README.md) | [Info](workflow/SupportingData/Agriculture-IrrigatedLandsRaster/irrigated-lands-raster-map.md) |
| ***Agriculture - Irrigated Lands*** | [README](workflow/SupportingData/Agriculture-IrrigatedLands/README.md) | [Info](workflow/SupportingData/Agriculture-IrrigatedLands/irrigated-lands-map.md) |
| ***Municipal - Municipalities*** | [README](workflow/SupportingData/Municipal-Municipalities/README.md) | [Info](workflow/SupportingData/Municipal-Municipalities/municipalities-map.md) |
| ***Water Supply - Water Providers*** | [README](workflow/SupportingData/WaterSupply-WaterProviders/README.md) | [Info](workflow/SupportingData/WaterSupply-WaterProviders/water-providers-map.md) |
|                           | -----------| -------------------------------|
| ***Agriculture - Conservation Easements*** | | [Content Page](web/content-pages/conservation-easements.md) |
| ***Environment - Open Lands*** | | [Content Page](web/content-pages/open-lands.md) |
| ***Municipal - Water Dedication Policies*** | [README](workflow/SupportingData/Municipal-WaterDedicationPolicies/README.md) | [Info](workflow/SupportingData/Municipal-WaterDedicationPolicies/municipal-water-dedication-policies-map.md) |
| ***Municipal - Water Rental Programs*** | [README](workflow/SupportingData/Municipal-WaterRentals/README.md) | [Info](workflow/SupportingData/Municipal-WaterRentals/municipal-water-rentals-map.md) |
| ***Water Transfer - Case Studies*** | [README](workflow/SupportingData/WaterTransfer-CaseStudies/README.md) | [Info](workflow/SupportingData/WaterTransfer-CaseStudies/transfer-case-studies-map.md) |
| ***Water Transfer - Interruptible Supply Agreements*** | | [Content Page](web/content-pages/interruptible-supply.md) |
| ***Water Transfer - Substitute Water Supply Plans*** | | [Content Page](web/content-pages/swsp.md) |
| ***Baseline Scenario /*** | ===========| ===============================|
| ***Synopsis - Summary of Baseline Analysis*** | | [Info](workflow/BaselineScenario/00-Synopsis/synopsis.md) |
| ***County Population*** | [README](workflow/BaselineScenario/01-CountyPopulation/README.md) | [Info](workflow/BaselineScenario/01-CountyPopulation/county-population.md) |
| ***Municipality Population*** | [README](workflow/BaselineScenario/02-MunicipalityPopulation/README.md) | [Info](workflow/BaselineScenario/02-MunicipalityPopulation/municipalities-map.md) |
| ***Scenario 1 /*** | ===========| ===============================|
| ***Synopsis - Placeholder for Additional Scenarios*** | | Summary of Scenario 1 analysis (placeholder for future scenario analysis). |

## Development Environment ##

This section provides an overview of the development environment.

### Quick Start ###

Do the following to set up a new development environment, assuming that development tools are installed.
Skip software installation steps if tools have been previously installed.
See the next section for more information about installing necessary tools.
**The following approach copies website content from `owf-infomapper-coagtransfer` repository
into the the `owf-app-infomapper-ng/infomapper/src/assets/app` folder
(it should be possible to use a symbolic link rather than copy, but this has not worked on Windows).**

1. On windows, create a folder `C:\Users\user\owf-dev\InfoMapper-COAgTransfer\git-repos`,
as per the [Repository Contents](#repository-contents) section above.
2. Typically, start a Git Bash or Cygwin terminal for development.
Command line scripts are run to process and copy files.
3. In the above folder, clone the repository:  `git clone https://github.com/OpenWaterFoundation/owf-infomapper-coagtransfer.git`
4. In the above repository, change to `build-util`.
5. Clone other related repositories, including InfoMapper:  `./git-clone-all-prod.sh`
6. Update the InfoMapper working files:
	1. Change to the `git-repos/owf-app-infomapper-ng/infomapper` folder.
	2. Install needed modules:  `npm install`
	3. **Do not run `npm audit fix`**, which can unexpectedly change Angular packages and cause errors building the software.
	The development team updates packages as Angular is updated.
	Options used with `npm audit` may be appropriate but have not been tested and have caused problems.
	4. Test: `ng serve --open`.
	The application should display in a browser with menu bar title ***Info Mapper***,
	which is the default when content is not available.
7. Create and test the Colorado Agricultural Water Transfer application content:
	1. Run the command files and scripts in the `git-repos/owf-infomapper-coagtransfer/workflow` folder
	to create and assemble content in the `web/` folder.
	**Automated execution of all steps together will be implemented at some point.**
	2. Run the `git-repos/owf-infomapper-coagtransfer/web/copy-to-infomapper.sh` script,
	which copies files in `web/` folder to the InfoMapper application files.
	3. In the `git-repos/owf-app-infomapper-ng/infomapper` folder, run `ng serve --open` to start the application server.
	The application should display in a browser with menu bar title ***Colorado Agricultural Water Transfer***.
8. Publish the application to the web:
	1. Run the `build-util/copy-to-owf-amazon-s3.sh` script to copy the
	InfoMapper `assets/app/` folder to the cloud.  A versioned and `latest` folder can be updated.
	See the deployed [latest Colorado Agricultural Water Transfer website](http://coagtransfer.openwaterfoundation.org/latest/#/content-page/home).

### Development Tools ###

The development environment for this repository depends primarily on software tools used to process and view data,
including the following.  Install the software in normal default locations.

* Git client:
	+ For example Git for Windows or Cygwin git.
* InfoMapper - open source web application software to visualize data:
	+ See the [owf-app-infomapper-ng](https://github.com/OpenWaterFoundation/owf-app-infomapper-ng) repository for information.
	+ Currently must be cloned - will create an installer in the future.
	+ See [InfoMapper Configuration](#infomapper-configuration) section.
* GeoProcessor - open source software for spatial data processing:
	+ Automates download and processing of spatial data.
	+ Command files (`*.gp`) in `process` folders indicate how to process spatial data and are
	committed to the repository.
	+ See the [GeoProcessor download page](http://software.openwaterfoundation.org/geoprocessor/).
* QGIS - open source geographic information system:
	+ Install the "Standalone Installation" (rather than OSGeo4W suite)
	corresponding to the GeoProcessor version.
	+ QGIS may be used to review data and create preliminary project files (`*.qgs`) for prototype maps.
	+ See [OWF / Learn QGIS](http://learn.openwaterfoundation.org/owf-learn-qgis/) for information on installing QGIS.
* TSTool - open source software for time series processing:
	+ Automates download and processing of time series data.
	+ Command files (`*.TSTool`) in `process` folders indicate how to process time series data and are
	committed to the repository.
	* See the [TSTool download page](http://software.openwaterfoundation.org/)
	for installation information.
* R - open source statistics software:
	+ Need to fill out.
* Python - open source scripting:
	+ Need to fill out.

### InfoMapper Configuration ###

The InfoMapper is an Angular application, which expects run-time configuration and data files to be
located in `owf-app-infomapper-ng/infomapper/src/assets/app` repository working files.
The `app-default/` folder that is distributed with the InfoMapper software will be used if
the `app/` folder is not found or there is a major error initializing the application,
and is used to confirm basic application configuration.

Because the InfoMapper is a general application,
specific configuration and data for this Colorado Agricultural Water Transfer information project cannot live in the InfoMapper repository.
Three options have been tested on Windows to provide custom configuration and data to the InfoMapper,
which applies to any implementation of the InfoMapper.

1. Copy files from the implementation repository to the InfoMapper `assets/app` folder:
	* This is typically be done with a script, either brute force to copy entire folder trees,
	or with options for selective copies.
	* The downside is that files, perhaps many files, would need to be repeatedly copied, which can be slow
	and will require additional disk space.
	However, if the content is being updated incrementally,
	then it is not difficult to only copy the updated content.
	* **This option is currently recommended on Windows because it does not require special configuration
	for windows to enable symbolic links, and because symbolic links on Windows do not seem to
	work propertly with Angular.**  The previous section describes using this approach.
2. Use symbolic link(s) in the InforMappper files to allow the InfoMapper to access data without doing a copy,
for example: `owf-app-infomapper-ng/infomapper/src/assets/app -> owf-infomapper-coagtransfer/web`.
	* All files live with the implementation repository and the InfoMapper `app` folder is in `.gitignore`.
	**This approach is desirable because published data live in the repository that is publishing the data
	and should be immediately detected by Angular when updated;
	however, it does not seem to work and is documented in a
	[Stack Overflow](https://stackoverflow.com/questions/62072054/angular-ng-serve-angular-cli-on-windows-cannot-find-assets-files-when-symbolic) article.**
	* Requires activating Windows 10 features to use symbolic links
	(see [Symlinks in Windows, MinGW, Git, and Cygwin](https://www.joshkel.com/2018/01/18/symlinks-in-windows/)).
		+ Add to `~/.bashrc_profile` in Git Bash and Cygwin the following:  `export MSYS=winsymlinks:nativestrict`
		+ Add to `C:\ProgramData\Git\config` in the `core` section:  `symlinks=true`
		+ Can also run: `git config --system core.symlinks true` (but need to do above to have an effect)
	* Requires confirming that symbolic links are working with all technologies involved,
	as indicated in the above article.
	It is recommended to create the symbolic links using Windows
	[mklink](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mklink) command and
	confirming that other development environment tools work with links,
	in order to do the minimal amount of extra configuration.
3. Similar to the above option but the symbolic link points in the opposite direction, for example:
`owf-infomapper-coagtransfer/web -> owf-app-infomapper-ng/infomapper/src/assets/app`.
	* All files live with the InfoMapper and the `app` folder is in `.gitignore`.
	* **This works but is undesirable due to issues noted below.  Hopefully the first option can be figured out and implemented.**
	* See above for enabling symbolic links.
	* Because `app` folder is git-ignored in the InfoMapper and the `dist/infomapper` symbolic link is git-ignored in
	this repository, any content that is static, such as `app-config.json` and `content-pages` must be saved in
	in this repository and copied to the `web/` linked folder.
	This is not ideal but is a work-around.
	Use the `web/x-copy-local-to-infomapper.sh` script to do this
	* **This approach has been abandoned as too complicated.**

## Maintainers ##

This repository is maintained by Open Water Foundation staff.
