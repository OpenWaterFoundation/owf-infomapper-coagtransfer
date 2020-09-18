# Municipal-Municipalities/doc #

This folder contains files for the ***Municipal - Municipalities*** product.

* [Introduction](#introduction)
* [Update Frequency](#update-frequency)
* [Datasets](#datasets)
* [Files](#files)
* [Workflow](#workflow)

-----------------------------

## Introduction ##

The ***Municipal - Municipalities*** map indicates the locations of municipalities in the Poudre Basin.

## Update Frequency ##

This product is updated infrequently,
based on changes in the municipalities dataset that is maintained by OWF.

## Datasets ##

The following are datasets for the map.

| **Dataset** | **Description** | **Data Source** |
| -- | -- | -- |
| Municipalities | Location of municipalities in the Poudre Basin. | The current statewide dataset was created by OWF for R&D and projects.  See the [`owf-data-co-municipalities` GitHub repository](https://github.com/OpenWaterFoundation/owf-data-co-municipalities). |

## Files ##

The following files and folders are used.

| **File/Folder** | **Description** | **Repo Ignore** |
| -- | -- | -- |
| `01a-download-municipalities.gp` | GeoProcessor command file to download data. | |
| `01b-download-municipal-boundaries.gp` | GeoProcessor command file to download data. | |
| `03-create-municipalities-map.gp` | GeoProcessor command file to create map. |
| `doc/` | This `README.md` and related files. | |
| `downloads/` | Downloaded files. | Yes - for downloaded files. |
| `layers/` | Layers and supporting files used in the map. | Yes - for generated files. |
| `municipalities.json` | Map configuration file. | Yes |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-municipalities.gp` | GeoProcessor | Download the municipalities data from OWF GitHub repository and rewrite to ensure latest GeoJSON format. |
| `01b-download-municipal-boundaries.gp` | GeoProcessor | Download the municipal boundaries data from Colorado Information Marketplace. |
| `03-create-municipalities-map.gp` | GeoProcessor | Create the map configuration file and copy map and layer files to the distribution folder. |
