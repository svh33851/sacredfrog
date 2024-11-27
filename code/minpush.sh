#!/bin/bash

# Define paths
HTML_FILE="index.html"
CSS_FOLDER="code"
OUTPUT_CSS="combined.min.css"
OUTPUT_HTML="index.min.html"

# Get the current timestamp (you can adjust the format as needed)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Step 1: Combine the CSS files into one temporary file
echo "Combining CSS files..."
cat "$CSS_FOLDER/pure-min.css" "$CSS_FOLDER/grids-responsive-min.css" "$CSS_FOLDER/style.css" > combined.css

# Step 2: Clean and Minify the CSS and save it as the final output
echo "Minifying CSS..."
cleancss -o "$OUTPUT_CSS" combined.css

# Step 3: Minify the HTML and save it as the final output
echo "Minifying HTML..."
minify --html "$HTML_FILE" > "$OUTPUT_HTML"

# Clean up the temporary combined CSS file
rm combined.css

# Step 4: Commit the changes to Git with a timestamped message
echo "Committing changes to Git..."
git add "$OUTPUT_CSS" "$OUTPUT_HTML"  # Add the output files
git commit -m "Minified CSS and HTML files - Timestamp: $TIMESTAMP"

echo "Process completed!"
echo "Minified CSS: $OUTPUT_CSS"
echo "Minified HTML: $OUTPUT_HTML"
