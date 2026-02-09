# Project Skyline

A bash script that visualizes your code repositories as a city skyline.

## Description

Project Skyline surveys your current directory and generates an ASCII art cityscape. Each "building" represents a subdirectory (project), where the height corresponds to the size of the codebase (Lines of Code).

## Features

- **Automated Surveying**: Scans immediate subdirectories to gather metrics.
- **Smart Metrics**: prioritize Lines of Code (LOC) for common languages (Java, JS, TS, Python, Shell, C++, etc.), falling back to file count for others.
- **Dynamic Scaling**: Automatically scales the skyline to fit within a fixed terminal height based on the largest project found.
- **Visualization**: Renders buildings with roofs and windows in the terminal.
- **Legend**: detailed breakdown of project names and their calculated sizes.

## Usage

1. Navigate to a directory containing your projects:
   ```bash
   cd ~/my-projects
   ```

2. Run the skyline script:
   ```bash
   ./skyline.sh
   ```

   Ensure the script has execution permissions:
   ```bash
   chmod +x skyline.sh
   ```

## Configuration

You can adjust the visualization settings by editing the variables at the top of `skyline.sh`:

- `MAX_HEIGHT`: Maximum height of buildings in terminal rows (default: 15).
- `BUILDING_WIDTH`: Width of one building in characters.
- `GAP_WIDTH`: Space between buildings.
