#!/bin/bash

# Image optimizer

# sudo apt install optipng pngcrush pngquant imagemagick mozjpeg webp

# Check if a directory path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi

# Assign the directory variable
DIR="$1"
OPTIMIZED_DIR="${DIR}/optimized"

# Create the optimized folder if it doesn't exist
mkdir -p "$OPTIMIZED_DIR"

# Iterate over all files in the directory
find "$DIR" -type f \( -iname "*.png" -or -iname "*.jpg" -or -iname "*.gif" \) | while read file; do
  # Process PNG files
  if [[ "$file" =~ \.png$ ]]; then
    # PNG Optimization
    echo "Optimizing PNG: $file"
    optipng -o7 "$file"  # General optimization
    pngcrush -brute "$file" "${OPTIMIZED_DIR}/$(basename "$file" .png)-crushed.png"  # Extra compression
    pngquant --quality=65-80 --ext .png --force "$file" && mv "${file%.png}-quant.png" "${OPTIMIZED_DIR}/$(basename "$file" .png)-quant.png"  # Lossy optimization
    convert "$file" -strip -interlace Plane -quality 85 "${OPTIMIZED_DIR}/$(basename "$file" .png)-optimized.png"  # ImageMagick optimization
  fi
  
  # Process JPG files
  if [[ "$file" =~ \.jpg$ ]]; then
    # JPG Optimization
    echo "Optimizing JPG: $file"
    jpegoptim --max=85 "$file"  # Lossless optimization
    cjpeg -quality 85 -optimize -progressive "$file" > "${OPTIMIZED_DIR}/$(basename "$file" .jpg)-optimized.jpg"  # Mozjpeg for better compression
  fi
  
  # Process GIF files
  if [[ "$file" =~ \.gif$ ]]; then
    # GIF Optimization
    echo "Optimizing GIF: $file"
    gifsicle --optimize=3 --colors 64 "$file" > "${OPTIMIZED_DIR}/$(basename "$file" .gif)-optimized.gif"  # Optimizing GIFs with reduced colors
  fi
done

# After optimizing all files, convert them to WebP

# Iterate again to convert all optimized images to WebP
find "$OPTIMIZED_DIR" -type f \( -iname "*.png" -or -iname "*.jpg" -or -iname "*.gif" \) | while read file; do
  if [[ "$file" =~ \.png$ || "$file" =~ \.jpg$ || "$file" =~ \.gif$ ]]; then
    # Convert each image to WebP
    echo "Converting to WebP: $file"
    cwebp -q 80 "$file" -o "${OPTIMIZED_DIR}/$(basename "$file" .${file##*.}).webp"  # Convert to WebP with quality 80
  fi
done

echo "Optimization and conversion to WebP completed in: $OPTIMIZED_DIR"
