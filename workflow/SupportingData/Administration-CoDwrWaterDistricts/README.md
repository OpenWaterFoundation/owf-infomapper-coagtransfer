# Administration-CoDwrWaterDistricts #

This folder contains files for the ***Administration - CO DWR Water Districts*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Administration - CO DWR Water Districts*** map includes Colorado Division of Water Resources (DWR)
Water Divisions and Districts, which correspond to river basins that are used in water administration.

Many datasets use "water district identifier" (WDID), which is a two-digit, zero padded water district
concatenated with 5 digit, zero padded, structure/location identifier.

## Update Frequency ##

This map is updated infrequently,
based on changes in CDSS water districts dataset.

## Files ##

The following files and folders exist in this folder.  Workflow files are described in the [Workflow](#workflow) section.

 **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `codwr-waterdistricts-map.json` | Map configuration file. | Yes |
| `codwr-waterdistricts-map.md` | Map information file. | Yes |
| `data/` | Data files used as input. | Yes |
| `downloads/` | Downloaded files. | No |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-water-districts-from-cdss.gp` | GeoProcessor | Download water districts layer from CDSS data website and save to `layers` folder. |
| `01b-download-water-divisions-from-cdss.gp` | GeoProcessor | Download water divisions layer from CDSS data website and save to `layers` folder. |
| `02b-create-dwr-offices-layer.tstool` | TSTool | Create water division offices layer from Excel data file. |
| `03-create-codwr-waterdistricts-map.gp` | GeoProcessor | Create a GeoMapProject map configuration file for use with the InfoMapper and copy to the `web` folder. |
