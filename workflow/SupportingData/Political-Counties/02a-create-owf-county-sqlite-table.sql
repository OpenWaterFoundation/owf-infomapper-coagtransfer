/*
  SQLite statement to create County table for OWF county dataset.
  - use the names as is from OWF county dataset
*/
CREATE TABLE IF NOT EXISTS county_owf (
  CountyName TEXT NOT NULL,
  State_Abbrev TEXT NOT NULL,
  FIPS_ID TEXT NOT NULL,
  FIPS_ID_Flag TEXT NOT NULL,
  FIPS_wState_ID TEXT NOT NULL,
  GNIS_ID INTEGER NOT NULL,
  GNIS_ID_Flag TEXT NOT NULL,
  DOLA_LG_ID INTEGER NOT NULL,
  DOLA_LG_ID_Flag TEXT NOT NULL,
  IBCC_Basin_CSV TEXT NOT NULL,
  Num_IBCC_Basin INTEGER NOT NULL,
  Comment TEXT DEFAULT ''
);
-- Try using default internal primary key
-- WITHOUT ROWID;
-- May put in the following:
-- CountyName text PRIMARY KEY,
