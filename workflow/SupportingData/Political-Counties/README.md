# Political-Counties #

This folder contains files for the ***Political - Counties*** map.

* [Overview](#overview)
* [Update Frequency](#update-frequency)
* [Datasets](#datasets)
* [Files](#files)
* [Workflow](#workflow)

-----------------------------

## Overview ##

The ***Political - Counties*** map includes counties and associated population time series.

## Update Frequency ##

This product is updated infrequently, based on changes in counties dataset.

## Files and Folders ##

The following files and folders are used.  Workflow files are described in the [Workflow](#workflow) section.

| **File/Folder** | **Description** | **Include in Repository?** |
| -- | -- | -- |
| `counties-map.json` | Map configuration file. | Yes |
| `counties-map.md` | Map information file. | Yes |
| `db/` | SQLite database created from DOLA population data. | No |
| `downloads/` | Downloaded files. | No |
| `graphs/` | Graph configuration files. | Yes |
| `layers/` | Layers and supporting files used in the map. | <ul><li>Yes - for configuration files</li><li>No - for generated files</li></ul> |
| `scripts/` | Utility scripts. | Yes |
| `ts/` | Time series files created from population database. | No - files are copied to `web` folder. |

## Workflow ##

The following describes the workflow steps, which should be run in the order shown to fully regenerate the information products.

| **Command File/Script** | **Software** | **Description** |
| -- | -- | -- |
| `01a-download-county-boundaries-from-cim.gp` | GeoProcessor | Download county boundaries from Colorado Information Marketplace. |
| `01b-download-county-data-from-owf.gp` | GeoProcessor | Download county dataset from Open Water Foundation, used to cross-reference identifiers. |
| `01c-download-county-population-data-from-dola.gp` | GeoProcessor | Download county population data from Department of Local Affairs. |
| `02a-create-county-sqlite-database.tstool` | TSTool | Create SQLite database containing DOLA population data, to facilitate data processing. |
| `02a-create-owf-county-sqlite-table.sql` | SQLite | SQL to create database population data table. |
| `02b-create-population-graph-config.tstool` | TSTool | Create graph configurations for population data. |
| `03-create-counties-map.gp` | GeoProcessor | Create a GeoMapProject file for use with the InfoMapper. |
