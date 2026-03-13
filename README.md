# Project Skyline

I built this because I wanted to see my projects at a glance—no dashboards, no UI, just raw info in the terminal.

It’s a bash script that scans your project directories and draws an ASCII skyline. Taller buildings = bigger codebases.

## How it works

- Scans immediate subdirectories.
- Counts lines of code for common languages (Java, JS, TS, Python, Shell, C++, etc.). Falls back to file count for others.
- Scales everything to fit your terminal—adjusts automatically based on the largest project.

Buildings get roofs and windows. A legend shows each project name and its LOC/file count.

## Usage

```bash
cd ~/my-projects
./skyline.sh
```

Make sure it’s executable first:

```bash
chmod +x skyline.sh
```

## Config

Edit the top of `skyline.sh` to tweak spacing:

- `MAX_HEIGHT` → max building height in rows (default: 15)
- `BUILDING_WIDTH` → characters per building (default: 10)
- `GAP_WIDTH` → spaces between buildings (default: 2)