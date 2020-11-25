# owf-app-ag-urban-workflow

Open Water Foundation application for agriculture/urban land use/water analysis, workflow files.

* [Background](#background)
* [Objectives](#objectives)

---------

## Background

Colorado's Front Range continues to experience population growth.
The Front Range population added approximately 600,000 people in the decade 
from 2000 to 2010 and is projected to add another 3 million people in the next four decades.
The projected growth means that the Front Range population will have doubled from 2000 to 2050.

In the past, significant agricultural dry-up has occurred along the Front Range,
with the transfer of water supplies from agricultural to urban use,
to fulfill the needs of population growth and development.
There is a growing sentiment among Colorado water leaders that we cannot grow in the future the way that we have grown in the past.
There are options as to how fast urbanization occurs and to what extent the dry up of agricultural lands transpires.
Options include denser growth, changes in water dedications,
and flexibility in assuring municipal water supplies and reserves.

In partnership with the Environmental Defense Fund (EDF),
WestWater Research (WWR) evaluated economic aspects of Alternative Water Transfer Methods (ATMs).
This work has contributed important insights into the challenges and opportunities for ATM development in Colorado. 
The primary state policy objective behind ATMs is to reduce the permanent dry-up of agricultural lands due to municipal water supply acquisitions,
particularly along the Colorado Front Range, which has high population growth and agricultural production.
An important aspect of understanding the opportunity for ATMs is to understand the drivers behind municipal growth and water acquisitions.
In 2018, WWR worked with EDF to develop an analysis of municipal growth and municipal water supply shortages for the Front Range to the year 2050. 
The analysis was both a water balance of individual municipal water providers and a spatial analysis to map
what land development and agricultural dry-up might look like under various future scenarios.
The analysis provided a better understanding of both the opportunity and benefits of ATMs for the Front Range.

While the analysis provided a better understanding of ATMs, it also required estimates about future population growth,
land development, and municipal water supplies that are inherently difficult to predict.
There is a broader and more powerful benefit to be gained from the analytical tools developed by WWR by creating
a public and open dashboard for evaluating alternative futures for the Front Range.
An online dashboard with maps and charts can allow any user to simulate municipal growth,
land development, and agricultural dry-up for the Front Range.

In 2019, the Open Water Foundation (OWF) began the next phase of the project,
discussed in this documentation and consisting of files in this repository.

## Objectives

There are two primary objectives in the creation of a municipal water demand and agricultural water transfer dashboard:

1. Automate input data processing and analysis steps so that the analysis is repeatable, updatable, and transparent
2. Publish the data input and results of the municipal water balance analysis to an online dashboard

This repository focuses on the first objective and consists of a series of workflows that automate data processing.
A separate repository contains the elements needed for development and deployment of the dashboard,
which will receive more attention once basic data products are available.

The WWR analysis tool consisted of Excel workbooks containing data such as population data,
municipal land area growth, current firm supply, total and future water supply,
total and future water demand, and projected shortages.
Data preparation and WWR analysis were performed in a largely manual fashion.
The input data for the WWR analysis focused on data at a 10-year interval.
However, many input datasets, such as population forecast data, are available on an annual basis or can be estimated as annual values.
OWF is updating the analysis to use annual data to the year 2050.
The use of annual data provides more consistency, flexibility, and scalability of the analysis.

## Repository Contents

The following summarizes the repository contents.

```
owf-ap-ap-urban-workflow/   Repository folder.
  baseline/                 Folder for baseline scenario files.
                            - used to develop the process
                            - will be copied and incrementally modified to run other scenarios
  doc-images/               Images for README.md.
  .gitattributes            Git repository settings.
  .gitignore                Git ignored files list.
  README.md                 This file.
  run/                      Folder containing dynamic files for baseline/scenario run.
                            - a folder in which multi-scenario model runs will be made
                            - contents are populated using scripts in the 'scripts' folder
  scripts/                  Scripts used to manipulate and run analyses.
```

## Approach

The following steps were performed to automate data processing and analysis.
See the READMEs for each folder in the `data-processing` folder for more detail.

### Step 1a:  Download Data

The basis of the municipal water supply analysis is population and projected population growth along the Front Range.
The first step is therefore to obtain population data.
Data are available for Colorado counties to 2050 from the Department of Local Affairs (DOLA)'s State Demography Office.
Historical population data (1980-2017) for counties and municipalities were also downloaded.

The WWR analysis also used municipal population estimates from the Denver Regional Council of Governments (DRCOG)
and looked at individual population projections provided by certain cities,
such as Fort Collins, Greeley, and Pueblo, but for this analysis, it was agreed by WWR and OWF to strictly use DOLA data.

It is envisioned that organizations can supplement DOLA and DRCOG data with their own data.

**This is executed periodically to update the core data.**

### Step 1b:  Pre-Process Downloaded Data

Data from the previous step were cleaned (such as removing extra white space and correcting spelling errors in municipality names)
and reorganized to be in a more useful form for processing.

**This is executed periodically consistent with step 1a to update the core data.**

### Step 2:  [Calculate Population Projections](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/00-Calculate-PopulationProjections)

While population forecast data are available for counties to 2050, municipal population forecast data are not.  To estimate municipal population 
to 2050, municipal populations were summarized by county for 2017.  This proportion of the total county population that is municipal was held 
constant to 2050.  Any remaining county population that was not considered part of a municipality is considered "Unincorporated Area" for that 
county.  

### Step 3:  [Calculate Municipal and Water District Areas](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/01-Calculate-Municipal-WaterDistrictAreas)

The calculation of municipal and water district areas is necessary for several reasons, such as for calculating population densities and the 
amount of overlap between municipalities and water districts.  This step uses rasterized spatial layers representing counties, municipal boundaries, 
water district boundaries, irrigated lands, and developed/developable lands that were provided by WWR.

### Step 4:  [Calculate Population Density](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/02-Calculate-PopulationDensity)

Population densities of municipalities are calculated based on 2018 data.  Density (persons per square mile) is calculated from the population 
calculated in Step 2 and municipal areas calculated in Step 3.  Municipalities within multiple counties have separate densities for each county.

### Step 5:  [Calculate Land Area Growth of Municipalities](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/03-Calculate-LandAreaGrowth)

Annual land area development (growth) estimates were made by taking the municipal population change from year to year and applying an estimated 
population density.  Population density was estimated to increase as municipalities grow and urbanize.  OWF used categories of "Low", "Medium", 
and "High" to describe the density assumptions.  Municipalities are split by county as needed.  The cumulative amount of new growth and the total 
amount of land area of each municipality for each year is calculated.  Municipal build-out was considered for those municipalities that cannot 
expand any further; in these cases it was assumed that population growth occurs through increased population density.

### Step 6:  [Calculate Future Municipal Population Density](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/04-Calculate-FutureMunicipalDensity)

Total land area calculations from Step 5 and the municipal population forecast data from Step 2 are used to calculate future population densities 
to 2050. 

### Step 7:  [Calculate Water District Population within Municipalities](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/05-Calculate-WaterDistrictPopulation-withinMunis)

Water districts often serve populations that are within municipalities, but a proportion of the district's service area may also be contained 
within unincorporated county land.  To estimate water district populations, the amount of population that is within a municipality was first estimated, 
followed by the amount within unincorporated areas.  
The water district service population within a municipality was estimated as the pro-rata portion of the municipal land area within the water district. 
For example, a water district intersecting 22% of a municipal developed area was allocated 22% of that municipality's population.  The associated 
municipality's population is subsequently adjusted to account for this population in Step 9 so that there is not a double-counting of population. 

### Step 8:  [Calculate Water District Population within Unincorporated Areas](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/06-Calculate-WaterDistrictPopulation-withinUnincorporated)

To calculate the water district service population within unincorporated county land, OWF assumed that the unincorporated portion of a water 
district's population can be set as a constant proportion of the associated county's unincorporated population.  This was the same assumption used for 
calculating municipal population as a proportion of the county population.  This methodology differs from WWR's original analysis.
The proportion of a water district's developed land within intersecting unincorporated county land that is also developed is multiplied by the 
intersecting unincorporated county population estimates up to 2050 to estimate the population of the water district within the associated 
unincorporated county.

### Step 9:  [Adjust Municipal Population Based on Water District Population Estimates](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/07-Adjust-MunicipalPopulation)

Water district populations contained within municipalities were calculated in Step 7.  To avoid double-counting, population was therefore lowered 
accordingly for municipalities. 

### Step 10:  [Calculate Land Area Growth of Water Districts](github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/08-Calculate-WaterDistrict-LandGrowth)

Annual land area development (growth) estimates were made by taking the water district population change from year to year and applying an estimated 
population density. Water districts are split by municipality and county as needed.  The cumulative amount of new growth and the total amount 
of land area of each water district for each year is calculated.  District build-out was considered for those districts that cannot expand any 
further; in these cases it was assumed that population growth occurs through increased population density.

### Step 11:  [Check Population Totals](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/09-Check-Population)

This step is a basic data check on the population calculations from previous steps. Municipal population estimates calculated in Step 2 and adjusted in Step 9 
are summed with water district population estimates calculated in Step 7 and Step 8.  The summed population numbers are compared to the county population 
estimates from DOLA.

### Step 12:  [Calculate Water Demand of Municipalities and Water Districts](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/10-Calculate-Demand)

Municipal and water district water demand is calculated as population multiplied by water use estimates in the form of gallons per capita 
per day (GPCD).  Amounts are converted to acre-feet per year.  GPCD estimates as compiled from water supply reports were considered 'normal' 
estimates.  Two other GPCD estimates, categorized as 'efficient' and 'inefficient' were considered.  An efficient GPCD was calculated as the 
normal GPCD multiplied by 0.85.  An inefficient GPCD was calculated as the normal GPCD multiplied by 1.15.

### Step 13:  [Map Land Development of Municipalities and Water Districts](https://github.com/OpenWaterFoundation/owf-app-ag-urban-workflow/tree/master/data/data-processing/11-Map-LandDevelopment)

The overall objective of this step is to spatially identify where new population will be located along the Front Range and to estimate how 
much growth occurs onto irrigated vs. non-irrigated lands. The amount of annual new growth in square miles for each water provider is 
converted to a count of cells(pixels) in the raster files.  The cells represent potentially developable land that will be reclassified 
as developed.  Cells are selected for reclassification as follows:
* The cell must be classified as Potentially Developable
* The cells closest to already developed land are selected first and growth occurs in a radial fashion
* Irrigated lands are given first priority

### Step 14:  Calculate Water Supply of Municipalities and Water Districts

TO BE COMPLETED

### Step 15:  Calculate Water Shortage of Municipalities and Water Districts

TO BE COMPLETED

### Step 16:  Acquisition Alternatives (Permanent Dry-Up vs. Fallowing)

TO BE COMPLETED
