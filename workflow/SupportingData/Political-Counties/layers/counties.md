# Layer: Colorado Counties

The Colorado Counties layer contains all counties in Colorado, colored as follows:

| **Color** | **Description** |
| -- | -- |
| **<span style="color:#000000">Black</span>** | Poudre Basin outline. |
| **<span style="color:#003cb3">Blue</span>** | Counties that provide water to the Poudre Basin via transbasin diversions. |
| **<span style="color:#59b300">Dark green</span>** | Counties that physically intersect the Poudre Basin:  Larimer and Weld counties. |
| **<span style="color:#b3ff66; background-color:#999999">Light green</span>** | Counties that are within the South Platte basin and benefit from the Poudre directly or indirectly (**more detail will be added in the future**). |
| **<span style="color:#ffff00; background-color:#999999">Yellow</span>** | Counties that currently or in the future will benefit from transbasin diversions out of the Poudre Basin (**more detail will be added in the future**). |
| **<span style="color:#999999">Gray outline</span>** | Other counties. |

Popup graphs are available for county population.

## Data Sources

The following are data sources for this map:

| **Resource** | **Source** |
| -- | -- |
| County boundaries map layer. | [Counties in Colorado](https://data.colorado.gov/Transportation/Counties-in-Colorado/67vn-ijga) map layer dataset from Colorado Information Marketplace. |
| County annual population time series | [Total Population by County by Year](https://data.colorado.gov/Demographics/Total-Population-by-County-by-Year/9dd2-kw29) dataset on Colorado Information Marketplace, **currently used, but are updating to use datasets from DOLA's website - see the Colorado Counties map documentation**. |

## Workflow

The workflow to create the map can be found in the [GitHub repository](https://github.com/OpenWaterFoundation/owf-infomapper-poudre/tree/master/workflow/BasinEntities/Political-Counties).
