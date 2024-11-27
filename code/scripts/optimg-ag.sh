#!/bin/bash

# Check if the directory is provided
if [ -z "$1" ]; then
  echo "Usage: aggressive-optimg /path/to/folder"
  exit 1
fi

# Input and output directories
DIRECTORY="$1"
AGGRESSIVE_DIR="${DIRECTORY}/optimized-aggressive"

# Subdirectories for each optimization method
REDUCED_COLOR_DIR="${AGGRESSIVE_DIR}/reduced-color-depth-folder"
STRIP_TRANSPARENCY_DIR="${AGGRESSIVE_DIR}/strip-transparency-folder"
EIGHT_BIT_DIR="${AGGRESSIVE_DIR}/8bit-folder"
WEBP_LOSSY_DIR="${AGGRESSIVE_DIR}/webp-lossy-folder"
ALL_COMBINED_DIR="${AGGRESSIVE_DIR}/all-combined-folder"

# Create output directories
mkdir -p "$REDUCED_COLOR_DIR" "$STRIP_TRANSPARENCY_DIR" "$EIGHT_BIT_DIR" "$WEBP_LOSSY_DIR" "$ALL_COMBINED_DIR"

# Function to remove EXIF data
strip_exif() {
  exiftool -all= -overwrite_original "$1"
}

# Function for Reduced Color Depth (PNG)
reduce_color_depth() {
  for img in "$DIRECTORY"/*.png; do
    [ -f "$img" ] || continue
    pngquant --quality=50-70 --nofs --speed 1 --force "$img" --output "$REDUCED_COLOR_DIR/$(basename "$img")"
    strip_exif "$REDUCED_COLOR_DIR/$(basename "$img")"
  done
}

# Function for Strip Transparency
strip_transparency() {
  for img in "$DIRECTORY"/*.png; do
    [ -f "$img" ] || continue
    convert "$img" -background white -alpha remove -quality 85 "$STRIP_TRANSPARENCY_DIR/$(basename "$img")"
    strip_exif "$STRIP_TRANSPARENCY_DIR/$(basename "$img")"
  done
}

# Function to Convert to 8-bit (PNG)
convert_to_8bit() {
  for img in "$DIRECTORY"/*.png; do
    [ -f "$img" ] || continue
    convert "$img" -depth 8 "$EIGHT_BIT_DIR/$(basename "$img")"
    strip_exif "$EIGHT_BIT_DIR/$(basename "$img")"
  done
}

# Function for WebP Lossy Compression
webp_lossy_compression() {
  for img in "$DIRECTORY"/*.{png,jpg,gif}; do
    [ -f "$img" ] || continue
    cwebp -q 60 -m 6 -mt -metadata none "$img" -o "$WEBP_LOSSY_DIR/$(basename "$img" .${img##*.}).webp"
  done
}

# Function for Combined Optimization
combine_all_methods() {
  for img in "$DIRECTORY"/*.{png,jpg,gif}; do
    [ -f "$img" ] || continue

    temp_combined="$ALL_COMBINED_DIR/temp_$(basename "$img")"

    # Step 1: Resize to 8-bit
    convert "$img" -depth 8 "$temp_combined"

    # Step 2: Remove transparency if needed
    convert "$temp_combined" -background white -alpha remove "$temp_combined"

    # Step 3: Compress with lossy WebP
    cwebp -q 60 -m 6 -mt -metadata none "$temp_combined" -o "$ALL_COMBINED_DIR/$(basename "$img" .${img##*.}).webp"

    # Clean up temporary files
    rm -f "$temp_combined"
  done
}

# Execute all methods
echo "Starting aggressive optimizations..."
reduce_color_depth
strip_transparency
convert_to_8bit
webp_lossy_compression
combine_all_methods
echo "Aggressive optimizations complete! Check '$AGGRESSIVE_DIR' for results."
