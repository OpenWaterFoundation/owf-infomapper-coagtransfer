# Agriculture-IrrigatedLandsRaster #

This folder contains files for the ***Agriculture - Irrigated Lands (Raster)*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Agriculture - Irrigated Lands (Raster)*** map includes irrigated lands as a raster layer,
which is used to perform the analysis.
A separate map is provided for raster layer because the other map with parcel data is slower to load and use.

## Update Frequency ##

This product is updated every 1 or several years, based on changes to irrigated lands.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `irrigated-lands-raster-map.json` | Map configuration file. | Yes |
| `irrigated-lands-raster-map.md` | Map information file. | Yes |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `03-create-irrigated-lands-raster-map.gp` | GeoProcessor | Create a GeoMapProject map configuration file for use with the InfoMapper and copy to the `web` folder. |
