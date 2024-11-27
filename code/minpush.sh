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

# Verify the combined CSS file exists
if [ -f combined.css ]; then
  echo "Combined CSS file created successfully."
else
  echo "Error: Combined CSS file was not created."
  exit 1
fi

# Step 2: Clean and Minify the CSS and save it as the final output
echo "Minifying CSS..."
cleancss -o "$OUTPUT_CSS" combined.css

# Verify if the CSS minification was successful
if [ -f "$OUTPUT_CSS" ]; then
  echo "CSS minification successful: $OUTPUT_CSS"
else
  echo "Error: CSS minification failed."
  exit 1
fi

# Step 3: Minify the HTML and save it as the final output
echo "Minifying HTML..."
minify --html "$HTML_FILE" > "$OUTPUT_HTML"

# Verify if the HTML minification was successful
if [ -f "$OUTPUT_HTML" ]; then
  echo "HTML minification successful: $OUTPUT_HTML"
else
  echo "Error: HTML minification failed."
  exit 1
fi

# Clean up the temporary combined CSS file
rm combined.css

# Step 4: Commit the changes to Git with a timestamped message
echo "Committing changes to Git..."
git add "$OUTPUT_CSS" "$OUTPUT_HTML"  # Add the output files
git commit -m "Minified CSS and HTML files - Timestamp: $TIMESTAMP"

echo "Process completed!"
echo "Minified CSS: $OUTPUT_CSS"
echo "Minified HTML: $OUTPUT_HTML"
