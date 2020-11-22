# Administration-WaterDistricts/doc #

This folder contains files for the ***Administration - CO DWR Water Districts*** product.

* [Introduction](#introduction)
* [Update Frequency](#update-frequency)
* [Datasets](#datasets)
* [Files](#files)
* [Workflow](#workflow)

-----------------------------

## Introduction ##

The ***Administration - CO DWR Water Districts*** map indicates Colorado Division of Water Resources (DWR)
Water Districts, which are used to administer water.

Many datasets use "water district identifier" (WDID), which is a two-digit, zero padded water district
concatenated with 5 digit, zero padded, structure/location identifier.

## Update Frequency ##

This product is updated infrequently,
based on changes in CDSS water districts dataset.

## Datasets ##

The following are datasets for the map.

| **Dataset** | **Description** | **Data Source** |
| -- | -- | -- |
| CO DWR Water Districts | Colorado Division of Water Resources water district boundaries. | The data is originally from a statewide layer downloaded from the [State of Colorado CDSS website](https://www.colorado.gov/pacific/cdss/gis-data-category).  It was then processed by OWF to split into water division 1 extent and is available on the [CDSS Spatial Datasets for Colorado Water Districts and Divisions](http://data.openwaterfoundation.org/co/cdss-data-spatial-bybasin/) website.  **The OWF dataset is older and uses the original GeoJSON specification.  The workflow reads the old GeoJSON and writes in latest specification.** |

## Files ##

The following files and folders are used.

| **File/Folder** | **Description** | **Repo Ignore** |
| -- | -- | -- |
| `.gitignore` | Indicates which files should be ignored in the repository. | |
| `01a-download-water-districts.gp` | GeoProcessor command file to download water districts dataset. | |
| `01b-download-water-division.gp` | GeoProcessor command file to download water division dataset. | |
| `02b-create-dwr-offices-layer.gp` | GeoProcessor command file to create division office layer (**not currently used**). | |
| `02b-create-dwr-offices-layer.tstool` | TSTool command file to create division office layer. | |
| `03-create-map-codwr-waterdistricts.gp` | GeoProcessor commandn file to create map. | |
| `codwr-waterdistricts.json` | Map configuration file. | Yes |
| `data/` | Data files used as input and stored in the repository. | |
| `doc/` | This `README.md` and related files. | |
| `downloads/` | Downloaded files. | Yes - for downloaded files. |
| `layers/` | Layers and supporting files used in the map. | Yes - for generated files. |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-water-districts.gp` | GeoProcessor | Download water districts layer from OWF CDSS data website and save to `layers` folder. |
| `01b-download-water-division.gp` | GeoProcessor | Download water division layer from OWF CDSS data website and save to `layers` folder. |
| `02b-create-dwr-offices-layer.gp` | GeoProcessor | Create water division offices layer from Excel file. **Currently not used - instead, use the TSTool command file.** |
| `02b-create-dwr-offices-layer.tstool` | TSTool | Create water division offices layer from Excel file. |
| `03-create-map-codwr-waterdistricts.gp` | GeoProcessor | Create a GeoMapProject file for use with the InfoMapper. |
