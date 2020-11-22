#!/bin/sh
#
# Convert the WaterProviders.csv file to table row format that can be included in the WaterProviders.md file.
# - must copy and paste into the WaterProviders.md file

echo ""
echo "Sorted by raster value (DOES NOT WORK)..."
echo ""

# TODO smalers 2020-11-19 need to make this work.

cat ../layers/WaterProviders.csv | awk 'BEGIN {
FS = ","
}
{
printf("| `%s` | %s |\n", $1, $2)
}' | sort

echo ""
echo "Sorted by water providers..."
echo ""

cat ../layers/WaterProviders.csv | awk 'BEGIN {
FS = ","
}
{
printf("| %s | `%s` |\n", $2, $1)
}'
