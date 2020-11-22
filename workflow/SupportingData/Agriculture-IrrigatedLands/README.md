# SupportingData / Agriculture-IrrigatedLands #

This folder contains files for the ***Agriculture - Irrigated Lands*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Supporting Data / Agriculture - Irrigated Lands*** map includes irrigated lands as a parcel layer and raster layer.
The raster layer is used to perform the analysis.
A separate map is provided for only raster layer because this map is slower to load and use.

## Update Frequency ##

This product is updated every 1 or several years, based on changes to irrigated lands.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `irrigated-lands-map.json` | Map configuration file. | Yes |
| `irrigated-lands-map.md` | Map information file. | Yes |
| `downloads/` | Downloaded files. | No |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01-download-irrigated-lands-from-dwr.gp` | GeoProcessor | Download irrigated lands layers from CDSS data website and save to `layers` folder. |
| `03-create-irrigated-lands-map.gp` | GeoProcessor | Create a GeoMapProject map configuration file for use with the InfoMapper and copy to the `web` folder. |
