# Map: Municipality Population

* Overview
* Analysis Process
* Other Scenarios
* Map Layer Groups

--------------

## Overview

The Municipality Population map provides population information about Colorado municipalities.
Click on a municipality marker and then view its estimated historical population
and population forecast.

Large municipalities may be served by multiple water providers
(see also the ***Supporting Data / Water Supply - Water Providers*** map),
which are typically utilities and special districts.
Depending on location, municipalities may rely on surface water and groundwater.

## Analysis Process ##

The following table summarizes analysis steps.

Forecasted population for each municipality is **not** estimated by DOLA in a public dataset.
Therefore, the forecasted population for each municipality was estimated by projecting
historical county population fractions forward.

| **Analysis Process Description** | **Important Assumptions and Estimates** |
| -- | -- |
| <ul><li>County population forecast data from DOLA to 2050 is used as core forecast data (see above menu for more information).</li><li>Use historical municipality population to calculate the fraction of county population attributed to each municipality, and repeat the last historical year's fraction as the forecast to 2050.</li><li>Multiply the fraction for each municipality by the county population forecast in each year to estimate the population for each municipality in each forecast year.</li><li>If a municipality exists in multiple counties (21 of 271 municipalities), the population part in each county is forecasted and then the parts are added to estimate the municipality population forecast total.</li><li>The population forecast for unincorporated county is the remainder after municipal population is subtracted from the county total population forecast.</li><li>Special care is taken for Broomfield, for which the municipality and county data are the same starting in 2000.  Prior to 2000, Broomfield contributed population to Adams, Boulder, Jefferson, and Weld conties.</li></ul>[See repository for workflow files.](https://github.com/OpenWaterFoundation/owf-infomapper-coagtransfer/tree/master/workflow/BaselineScenario/02-MunicipalPopulation)| <ol><li>The population growth rate for municipalities in a county will be similar to overall county population growth rate.</li><li>Municipalities that exist in more than one county may have different growth rates in each of those counties.</li><li>Upper limits on municipal growth are not implemented in this step. Limits on municipal land growth and changes to population density are determined in later steps.</li></ol>|

## Other Scenarios ##

Specific scenarios may be implemented in the future where more informed municipal population is specified,
for example using Denver Regional Council of Governments or municipality data.

## Map Layer Groups

The following layer groups are included in this map.

| **Layer Group** | **Description** |
| -- | -- |
| Colorado Municipalities | Colorado municipalities including area boundaries. |
| Background Layers | Background layers that provide a frame of reference. |
