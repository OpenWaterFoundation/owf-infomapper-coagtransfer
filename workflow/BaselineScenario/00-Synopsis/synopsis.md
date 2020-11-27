# Baseline Scenario / Synopsis 

The baseline scenario is an analysis of potential municipal growth onto agricultural lands using
basic assumptions and readily available data.

The following table lists the analysis workflow steps.
Each ***Baseline Scenario*** menu item corresponds to results for the analysis step.

| **Analysis Step** | **Description** | **Important Assumptions and Estimates** |
| -- | -- | -- |
| ***Synopsis*** | Contains configuration information for the scenario.<br>[See repository for workflow files.](https://github.com/OpenWaterFoundation/owf-infomapper-coagtransfer/tree/master/workflow/BaselineScenario/00-Synopsis) | |
| ***1. Data Preparation*** | Datasets from ***Supporting Data*** are used as input to create datasets for the baseline scenario.  This includes converting polygon boundary layers into raster layers that are used for the analysis. | |
| ***2a. County Population*** | Determine county population forecasts to 2050.  Use Colorado State Demographer data.  The data are the same as the ***Supporting Data / Political - Counties*** map - click on a county to view population time series.<br>[See repository for workflow files.](https://github.com/OpenWaterFoundation/owf-infomapper-coagtransfer/tree/master/workflow/SupportingData/Political-Counties) | <ol><li>DOLA's historical estimate and forecast of county population are the best estimate available for a baseline scenario.</li></ol><br>|
| ***2b. Municipality Population*** | Determine municipal population forecasts to 2050:  <ul><li>County population forecast data from DOLA to 2050 is used as core forecast data (see above menu for more information).</li><li>Use historical municipality population to calculate the fraction of county population attributed to each municipality, and repeat the last historical year's fraction as the forecast to 2050.</li><li>Multiply the fraction for each municipality by the county population forecast in each year to estimate the population for each municipality in each forecast year.</li><li>If a municipality exists in multiple counties (21 of 271 municipalities), the population part in each county is forecasted and then the parts are added to estimate the municipality population forecast total.</li><li>The population forecast for unincorporated county is the remainder after municipal population is subtracted from the county total population forecast.</li><li>Special care is taken for Broomfield, for which the municipality and county data are the same starting in 2000.  Prior to 2000, Broomfield contributed population to Adams, Boulder, Jefferson, and Weld conties.</li></ul>[See repository for workflow files.](https://github.com/OpenWaterFoundation/owf-infomapper-coagtransfer/tree/master/workflow/BaselineScenario/02-MunicipalPopulation)| <ol><li>The population growth rate for municipalities in a county will be similar to overall county population growth rate.</li><li>Municipalities that exist in more than one county may have different growth rates in each of those counties.</li><li>Upper limits on municipal growth are not implemented in this step. Limits on municipal land growth and changes to population density are determined in later steps.</li></ol>|
| ***3. Municipality and Water District Area*** | Area is computed for use in population density calculations. | |
| ***4. Population Density*** | Population and area are used to compute population density for the starting year of the analysis (2018). | |
| ***5. Municipal Land Area Growth*** | Population growth and density are used to estimate land area growth into the future.  Low, medium, and high densities are used. | |
| ***6. Future Municipal Population Density*** | Total land are calculations from Step 5 and municipal population forecast data from Step 2 are used to calculate future population densities to 2050. | |
| ***7. Water District Population within Municipalities*** | The population served within municipalities is estimated. | |
| ***8. Water District Population within Unincorporated Areas*** | The population served within unincorporated areas is estimated. | |
| ***9. Adjust Municipal Population Based on Water District Population*** | The population served is reduced when the service area overlaps municipal area. | |
| ***10. Water District Land Growth*** | Water district land growth is estimated using population growth and density, constraining to build-out area. | |
| ***11. Population Checks*** | Municipal population estimates from Steps 2 and 9 and water district population estimated from steps 7 and 8 and summed and compared to initial county population data from DOLA. | |
| ***12. Water Demand*** | Water demand is estimated as population multiplied by water use in gallons/capita/day (GPCD). | |
| ***13. Land Development*** | Estimate where new population will be estimated by growing onto previously undeveloped land that is classified as developable. | |
