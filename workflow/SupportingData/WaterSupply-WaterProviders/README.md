# SupportingData / WaterSupply-WaterProviders #

This folder contains files for the ***Supporting Data / Water Supply - Water Providers*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Supporting Data / Water Supply - Water Providers*** map includes the locations of water providers as markers and boundaries.

## Update Frequency ##

This product is updated infrequently,
based on changes in the special districts dataset from the Department of Local Affairs.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `data/` | List of water providers included in the analysis. | Yes |
| `downloads/` | Downloaded files. | No |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |
| `scripts/` | Utility scripts. | Yes |
| `water-providers-map.json` | Map configuration file. | Yes |
| `water-providers-map.md` | Map information file. | Yes |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-water-providers-from-owf.gp` | GeoProcessor | Download the water-providers data from Open Water Foundation GitHub repository and save to the `layers` folder for points. |
| `01b-download-special-districts-from-dola.gp` | GeoProcessor | Download the special districts boundaries data from Colorado Department of Local Affairs and save to the `layers` folder. |
| `01c-download-denver-water-boundary.gp` | GeoProcessor | Process the Denver Water service area boundary provided by Denver Water and save to the `layers` folder. |
| `03-create-water-providers-map.gp` | GeoProcessor | Create the map configuration file for use with the InfoMapper and copy files to the `web` folder. |
