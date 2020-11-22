#!/bin/sh
#
# Convert the Municipality.csv file to table row format that can be included in the Municipality.md file.
# - must copy and paste into the Municipality.md file

echo ""
echo "Sorted by raster value..."
echo ""

cat ../layers/Municipality.csv | awk 'BEGIN {
FS = ","
}
{
printf("| `%s` | %s |\n", $1, $2)
}'

exit 0

# No need to do this since the original csv value and municipality sort the same.

echo ""
echo "Sorted by municipality..."
echo ""

cat ../layers/Municipality.csv | awk 'BEGIN {
FS = ","
}
{
printf("| %s | `%s` |\n", $2, $1)
}' | sort
