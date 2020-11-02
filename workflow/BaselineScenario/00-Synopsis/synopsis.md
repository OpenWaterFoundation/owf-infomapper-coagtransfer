# Baseline Scenario / Synopsis 

The baseline scenario is an analysis of urban growth onto agricultural lands using
basic assumptions.

The following table lists the analysis workflow steps.
Each ***Baseline Scenario*** menu item corresponds to results for the analysis step.

| **Analysis Step** | **Description** | **Important Assumptions/Estimates** |
| -- | -- | -- |
| ***County Population*** | Determine county population forecasts to 2050.  Use Colorado State Demographer data.  See the ***Supporting Data / Political - Counties*** map - click on a county to view population time series. | <ol><li>DOLA's historical estimate and forecast of county population is the best estimate available for a baseline scenario.</li></ol> |
| ***Municipality Population*** | Determine municipal population forecasts to 2050:  <ul><li>County population forecast data from DOLA to 2050 is used as core forecast data (see above menu for more information).</li><li>Use historical municipality population to calculate the fraction of county population attributed to each municipality, and repeat the last historical year's fraction as the forecast to 2050.</li><li>Multiply the fraction for each municipality by the county population forecast in each year to estimate the population for each municipality in each forecast year.</li><li>If a municipality exists in multiple counties (21 of 271 municipalities), the population part in each county is forecasted and then the parts are added to estimate the municipality population forecast total.</li><li>The population forecast for unincorporated county is the remainder after municipal population is subtracted from the county total population forecast.</li><li>Special care is taken for Broomfield, for which the municipality and county data are the same starting in 2000.  Prior to 2000, Broomfield contributed population to Adams, Boulder, Jefferson, and Weld conties.</ul> | <ol><li>The population growth rate for municipalities in a county will be similar to overall county population growth rate.</li><li>Municipalities that exist in more than one county may have different growth rates in each of those counties.</li><li>Upper limits on municipal growth are not implemented in this step. Population density is determined in later steps.</li></ol> |
