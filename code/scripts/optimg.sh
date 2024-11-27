#!/bin/bash

# Check if the directory is provided
if [ -z "$1" ]; then
  echo "Usage: optimg /path/to/folder"
  exit 1
fi

# Directory path from the argument
DIRECTORY="$1"
OUTPUT_DIR="${DIRECTORY}/optimized_images"
WEBP_DIR="${OUTPUT_DIR}/webp"

# Create output directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$WEBP_DIR"

# Parallel processing setup
NUM_CORES=$(nproc)

# Function to remove metadata
strip_metadata() {
    exiftool -all= -overwrite_original "$1"
}

# Function to optimize PNG files
optimize_png() {
    find "$1" -iname "*.png" | xargs -P "$NUM_CORES" -I {} bash -c '
        img="{}"
        base=$(basename "$img")
        # Optimize with optipng (lossless compression)
        optipng -o7 "$img" -out "'"$OUTPUT_DIR"'/$base"
        # Further reduce color depth with pngquant (lossy compression)
        pngquant --quality=50-70 --nofs --speed 1 --ext .png --force "$img" --output "'"$OUTPUT_DIR"'/$base"
        # Strip metadata
        strip_metadata "'"$OUTPUT_DIR"'/$base"
    '
}

# Function to optimize JPG files
optimize_jpg() {
    find "$1" -iname "*.jpg" | xargs -P "$NUM_CORES" -I {} bash -c '
        img="{}"
        base=$(basename "$img")
        # Optimize with jpegoptim
        jpegoptim --strip-all --max=75 --dest="'"$OUTPUT_DIR"'" "$img"
        # Strip metadata
        strip_metadata "'"$OUTPUT_DIR"'/$base"
    '
}

# Function to optimize GIF files
optimize_gif() {
    find "$1" -iname "*.gif" | xargs -P "$NUM_CORES" -I {} bash -c '
        img="{}"
        base=$(basename "$img")
        # Optimize GIF with gifsicle
        gifsicle --optimize=3 --colors 64 "$img" > "'"$OUTPUT_DIR"'/$base"
        # Strip metadata
        strip_metadata "'"$OUTPUT_DIR"'/$base"
    '
}

# Function to convert images to WebP
convert_to_webp() {
    find "$1" -iname "*.png" -o -iname "*.jpg" -o -iname "*.gif" | xargs -P "$NUM_CORES" -I {} bash -c '
        img="{}"
        ext="${img##*.}"
        base=$(basename "$img" ."$ext")
        # Convert to WebP (lossy with quality 75%)
        cwebp -q 75 "$img" -o "'"$WEBP_DIR"'/$base.webp"
        # Strip metadata
        strip_metadata "'"$WEBP_DIR"'/$base.webp"
    '
}

# Run optimizations in parallel
optimize_png "$DIRECTORY"
optimize_jpg "$DIRECTORY"
optimize_gif "$DIRECTORY"
convert_to_webp "$DIRECTORY"

echo "Optimization complete! Optimized images are saved in $OUTPUT_DIR, and WebP images are in $WEBP_DIR."
