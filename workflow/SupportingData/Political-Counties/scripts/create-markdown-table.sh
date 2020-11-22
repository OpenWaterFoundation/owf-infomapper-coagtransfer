#!/bin/sh
#
# Convert the County.csv file to table row format that can be included in the County.md file.
# - must copy and paste into the County.md file

echo ""
echo "Sorted by raster value..."
echo ""

cat ../layers/County.csv | awk 'BEGIN {
FS = ","
}
{
printf("| `%s` | %s |\n", $1, $2)
}'

echo ""
echo "Sorted by county..."
echo ""

cat ../layers/County.csv | awk 'BEGIN {
FS = ","
}
{
printf("| %s | `%s` |\n", $2, $1)
}' | sort
