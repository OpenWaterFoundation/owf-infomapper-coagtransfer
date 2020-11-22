# BaselineScenario / 01-CountyPopulation #

This folder contains files for the ***Baseline Scenario / County Population*** page.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Files and Folders](#files-and-folders)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Baseline Scenario / County Population*** page refers to the ***Supporting Data / Political - Counties*** map.

## Update Frequency ##

This product is updated infrequently, based on changes in counties dataset.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `county-population.md` | County population information file. | Yes |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `03-county-population.gp` | GeoProcessor | Copy the info file to the `web` folder. |
