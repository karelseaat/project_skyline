# Plan: Project Skyline

## Goal
Create a script `skyline.sh` that renders your directories as a city skyline, where building dimensions reflect project size.

## Implementation Details
1. **Directory Traversal**
   - Iterate through immediate subdirectories of the current folder.
   - Skip hidden folders or non-project folders if necessary.

2. **Metrics Collection**
   - **Width**: `find . -type f | wc -l` (File count).
   - **Height**: `find . -type f -name "*.<ext>" | xargs wc -l` (Lines of Code).
     - *Alternative Height*: Disk usage `du -s`.
   - Optimization: Limit depth or extensions to keep it fast.

3. **Normalization**
   - Find the project with the max LOC/Size.
   - Scale heights to a max terminal height (e.g., 20 rows).
   - Normalize width (e.g., 1 character = 10 files).

4. **Rendering**
   - Create a 2D grid/buffer for the output.
   - "Draw" each building into the buffer.
     - Roof: `_`
     - Walls: `|`
     - Fill: ` ` or fill patterns based on language.
   - Print the buffer line by line from top to bottom.
   - Print the project names vertically or abbreviated below their buildings.

## Output
A bash script named `skyline.sh`.
