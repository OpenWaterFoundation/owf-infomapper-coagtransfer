# workflow-v1

This folder contains the original workflow scripts and command files created by the Open Water Foundation
(see the `owf-infomapper-coagtransfer-v0` archive repository),
but which have been updated to use relative paths and copy files from the archive repositories, as needed.
Python and R are primarily used for processing.
Running the analysis in this folder therefore recreates the original work to automate processing.

See the `workflow` files for the latest version, which uses relative paths and current workflow organization.
Python and R are used for processing some steps, with a greater use of TSTool and GeoProcessor
to provide a command language workflow with error handling for each command.

Data from WWR referred to as `data-orig/` are stored in a private repository `owf-infomapper-coagtransfer-data-wwr`
and provide the baseline scenario raster files.
This work can be fully automated in the future to use public datasets.

The step numbers and folders in this workflow match the original naming.
Dynamic files are ignored using `.gitignore` in this folder so as to minimize storing large files
and dynamic files in the repository.
