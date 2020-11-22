# BaselineScenario / 02-MunicipalityPopulation #

This folder contains files for the ***Baseline Scenario / Municipality Population*** page.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Baseline Scenario / County Population*** map includes historical and forecast municipality time series.

## Update Frequency ##

This product is updated infrequently, based on changes in counties dataset.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `graphs/` | Graph configuration files. | Yes |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |
| `municipalities-map.json` | Map configuration file. | Yes |
| `municipalities-map.md` | Map information file. | Yes |
| `ts/` | Time series files created from population database. | No - files are copied to `web` folder. |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `02-create-population-graph-config.tstool` | TSTool | Create graph configurations in `graphs` folder and time series in `ts` folder for population data. |
| `03-create-municipalities-map.gp` | GeoProcessor | Create the map configuration file for use with the InfoMapper and copy files to the `web` folder. |
