# SupportingData / Municipal-WaterRentals #

This folder contains files for the ***Supporting Data / Municipal - Water Rental Programs*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Supporting Data / Municipal - Water Rental Programs*** map indicates municipalities with water rental
programs, currently a limited example.

## Update Frequency ##

This product is updated infrequently,
based on changes in the water rental program dataset, currently a limited example.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `data/` | Data files for the map. | Yes |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |
| `municipal-water-rentals-map.json` | Map configuration file. | Yes |
| `municipal-water-rentals-map.md` | Map information file. | Yes |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `03-create-municipal-water-rentals-map.gp` | GeoProcessor | Create the map configuration file for use with the InfoMapper and copy files to the `web` folder. |
