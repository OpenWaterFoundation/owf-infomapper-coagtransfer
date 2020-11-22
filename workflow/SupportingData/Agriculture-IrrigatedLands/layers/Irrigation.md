# Layer: Irrigated Lands (Raster)

The Irrigated Lands (Raster) layer is a raster (image) created
by converting the irrigated lands polygon layer into a raster for the analysis area.
This raster layer is used to perform the analysis of municipal growth onto irrigated lands.

## Data Sources

The following are data sources for this layer:

| **Resource** | **Source** |
| -- | -- |
| Irrigated Lands raster layer. | The polygon municipal boundaries from CDSS were used to create the irrigated lands raster layer. |

## Workflow

The workflow to create the map can be found in the [GitHub repository](https://github.com/OpenWaterFoundation/owf-infomapper-poudre/tree/master/workflow/BasinEntities/Agriculture-IrrigatedLands).

## Raster Value 

| **Raster Value** | **Irrigation** |
| -- | -- |
| `1` | Irrigated |
| `2` | Not irrigated|
