# Baseline Scenario / Land Development

The objective of this step is to spatially identify where new population
will be located along the Front Range and to estimate how
much growth occurs onto irrigated vs. non-irrigated lands.
The amount of annual new growth in square miles for each water provider is
converted to a count of raster cells (pixels) in the raster layers.
The cells represent potentially developable land that will be reclassified as developed.
Cells are selected for reclassification as follows:

* The cell must be classified as `Potentially Developable`.
* The cells closest to already developed land are selected first and growth occurs in a radial fashion.
* Irrigated lands are developed first.
