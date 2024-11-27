#!/bin/bash

# Define paths
HTML_FILE="index-source.html"
CSS_FOLDER="code"
OUTPUT_CSS="$CSS_FOLDER/style.min.css"
OUTPUT_HTML="index.html"

# Get the current timestamp (you can adjust the format as needed)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Step 1: Combine the CSS files
echo "Combining CSS files..."
cat "$CSS_FOLDER/pure-min.css" "$CSS_FOLDER/grids-responsive-min.css" "$CSS_FOLDER/style.css" > $CSS_FOLDER/combined.css

# Step 2: Clean and Minify the CSS
echo "Minifying CSS..."
cleancss -o "$OUTPUT_CSS" $OUTPUT_CSS

# Step 3: Minify the HTML
echo "Minifying HTML..."
minify --html "$HTML_FILE" > "$OUTPUT_HTML"

# Clean up intermediate combined CSS file
rm combined.css

echo "Process completed!"
echo "Minified CSS: $OUTPUT_CSS"
echo "Minified HTML: $OUTPUT_HTML"

# Step 4: Commit the changes to Git with a timestamped message
echo "Committing changes to Git..."
git add .
echo "Output of 'git status':"
git status
git commit -m "Minified CSS and HTML files - Timestamp: $TIMESTAMP"

echo "now run 'git push origin main'"
