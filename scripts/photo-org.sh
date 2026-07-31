#!/bin/bash

# Requires bash version >=4.4
if [ "${BASH_VERSINFO[0]}" -lt 4 -a "${BASH_VERSINFO[1]}" -lt 4 ]; then
    echo "This script relies on bash version 4.4 or later. Your version is $BASH_VERSION"
    exit 1
fi

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <image_directory> <featureimage> <cardimage>"
    exit 1
fi

# Process featureimage
echo "Processing feature..."
magick $2 -resize 1920x1920\> -quality 85 "${1}/feature.webp"

# Process card
echo "Processing card..."
magick $3 -resize 600x600\> -quality 80 "${1}/card.webp"

# Process photos for gallery
readarray -d '' photos< <(find $1 -type f \( -iname *.jpg -o -iname *.heic -o -iname *.nef \) -print0)

i=1
photocount=${#photos[@]}
for photo in "${photos[@]}"
do
    echo "Processing image $i of $photocount..."
    filename=$(printf "$1/%02d.webp" "$i")
    magick $photo -resize 2000x2000\> -quality 90 $filename
    (( i ++ ))
done

# move originals
echo "Moving originals to subdirectory..."
mkdir -p $1/originals
for photo in "${photos[@]}"
do
    mv $photo $1/originals
done

echo "Finished!"
