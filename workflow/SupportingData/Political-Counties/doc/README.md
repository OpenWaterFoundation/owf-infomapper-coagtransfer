# Political-Counties/doc #

This folder contains files for the ***Political - Counties*** product.

* [Introduction](#introduction)
* [Update Frequency](#update-frequency)
* [Datasets](#datasets)
* [Files](#files)
* [Workflow](#workflow)

-----------------------------

## Introduction ##

The ***Political - Counties*** map indicates counties associated with the Poudre Basin,
in particular those that supply and consume water.
The counties layer is a foundational layer that is displayed on other maps.

## Update Frequency ##

This product is updated infrequently, based on changes in counties dataset.

## Datasets ##

The following are datasets for the map.

| **Dataset** | **Description** | **Data Source** |
| -- | -- | -- |
| County Boundaries | County boundaries. | The dataset is from [Colorado Information Marketplace (CIM)](https://data.colorado.gov/Transportation/Counties-in-Colorado/67vn-ijga), downloaded as a GeoJSON file to `downloads/counties.geojson`. |
| County Seats | County seat location. | **Need to add this layer.** |

## Files ##

The following files and folders are used.

| **File/Folder** | **Description** | **Repo Ignore** |
| -- | -- | -- |
| `01-download-counties.gp` | GeoProcessor command file to downloaded counties data. | |
| `03-create-counties-map.gp` | GeoProcessor command file to create map. | |
| `counties-map.json` | Map configuration file. | Yes |
| `doc/` | This `README.md` and related files. | |
| `downloads/` | Downloaded files. | Yes - for downloaded files. |
| `layers/` | Layers and supporting files used in the map. | Yes - for generated files. |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01-download-counties.gp` | GeoProcessor | Download counties layer. |
| `03-create-counties-map.gp` | GeoProcessor | Create the map configuration file and copy map and layer files to the distribution folder. |
