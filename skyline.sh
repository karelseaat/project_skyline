#!/bin/bash

# Configuration
MAX_HEIGHT=15      # Max height of buildings in terminal rows
BUILDING_WIDTH=4   # Width of one building in chars
GAP_WIDTH=1        # Gap between buildings

# Colors
COLOR_RESET="\033[0m"
COLOR_BUILDING="\033[44m" # Blue background
COLOR_ROOF="\033[0;34m"   # Blue text

echo "Surveying the city... (Calculating project sizes)"

# temporary file for data
DATA_FILE=$(mktemp)

# 1. Collect Data
# Format: "LOC Name"
# We'll use LOC (Lines of Code) as height. 
# Simple heuristic: count lines in source-like files.
max_loc=0
project_count=0

for dir in */ ; do
    # Remove trailing slash
    dirname=${dir%/}
    
    # Skip non-project folders if needed (e.g., hidden ones)
    if [[ $dirname == .* ]]; then continue; fi
    
    # Count lines in common source files
    # Error redirection 2>/dev/null hides errors if no files found
    loc=$(find "$dirname" -type f \( -name "*.java" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.sh" -o -name "*.html" -o -name "*.css" -o -name "*.go" -o -name "*.rs" -o -name "*.cpp" -o -name "*.c" -o -name "*.h" \) -not -path "*/node_modules/*" -not -path "*/target/*" -exec cat {} + 2>/dev/null | wc -l)
    
    # Fallback to file count if LOC is 0 (e.g. binary repo or unrecognized lang)
    if [ "$loc" -eq 0 ]; then
        loc=$(find "$dirname" -type f | wc -l)
        # Weight file count heavily so it shows up? Or treat as low?
        # Let's just treat it as raw size.
    fi

    # Record max for scaling
    if (( loc > max_loc )); then max_loc=$loc; fi
    
    echo "$loc $dirname" >> "$DATA_FILE"
    ((project_count++))
done

if [ "$project_count" -eq 0 ]; then
    echo "No projects found."
    rm "$DATA_FILE"
    exit 0
fi

echo "Found $project_count projects. Max Size: $max_loc units."
echo ""

# 2. Render Skyline
# We need to print line by line, from top (max_height) to bottom (1)

# Read data into arrays
names=()
heights=()
scaled_heights=()

while read -r loc name; do
    names+=("$name")
    heights+=("$loc")
    
    # Scale: (loc / max_loc) * MAX_HEIGHT
    # Ensure at least height 1 if loc > 0
    if (( loc == 0 )); then
        s_h=0
    else
        s_h=$(( loc * MAX_HEIGHT / max_loc ))
        if (( s_h == 0 )); then s_h=1; fi
    fi
    scaled_heights+=("$s_h")
done < "$DATA_FILE"

rm "$DATA_FILE"

# Print rows from top to bottom
for (( row=MAX_HEIGHT; row>=1; row-- )); do
    printf " " # Left padding
    
    for i in "${!names[@]}"; do
        h=${scaled_heights[$i]}
        
        if (( h >= row )); then
            # Part of the building
            if (( h == row )); then
                 # Roof line
                 printf "${COLOR_ROOF}____${COLOR_RESET} " 
            else
                 # Wall/Window
                 # Randomize windows slightly? No, keep clean.
                 printf "|__| "
            fi
        else
            # Sky
            printf "     "
        fi
    done
    echo ""
done

# 3. Print Base / Names
# Truncate names to width 4 to match buildings
printf " "
for name in "${names[@]}"; do
    # Get first 4 chars
    short_name="${name:0:4}"
    printf "%-4s " "$short_name"
done
echo ""

# Print full legend if space allows or user wants?
# Let's vertically print names if we want to be fancy, but that's complex bash.
# Instead, maybe just a list below.
echo ""
echo "Legend:"
for i in "${!names[@]}"; do
    printf "%-4s : %-30s (%d lines)\n" "${names[$i]:0:4}" "${names[$i]}" "${heights[$i]}"
done
