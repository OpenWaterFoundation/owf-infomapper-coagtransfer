# Municipal-Municipalities #

This folder contains files for the ***Municipal - Municipalities*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Municipal - Municipalities*** map includes the locations of municipalities as markers and boundaries,
with historical population time series.

## Update Frequency ##

This product is updated infrequently,
based on changes in the municipalities dataset from the Department of Local Affairs.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `downloads/` | Downloaded files. | No |
| `graphs/` | Graph configuration files. | Yes |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |
| `scripts/` | Utility scripts. | Yes |
| `ts/` | Time series files created from population database. | No - files are copied to `web` folder. |
| `municipalities-map.json` | Map configuration file. | Yes |
| `municipalities-map.md` | Map information file. | Yes |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-municipalities-from-owf.gp` | GeoProcessor | Download the municipalities data from Open Water Foundation GitHub repository and save to the `layers` folder for points. |
| `01b-download-municipal-boundaries-from-cim.gp` | GeoProcessor | Download the municipality boundaries data from Colorado Information Marketplace and save to the `layers folder. |
| `01c-download-municipal-rasters-from-owf.gp` | GeoProcessor | Download the municipality and development raster layers from Open Water Foundation repository and save to the `layers folder. |
| `02b-create-population-graph-config.tstool` | TSTool | Create graph configurations in `graphs` folder and time series in `ts` folder for population data. |
| `03-create-municipalities-map.gp` | GeoProcessor | Create the map configuration file for use with the InfoMapper and copy files to the `web` folder. |
