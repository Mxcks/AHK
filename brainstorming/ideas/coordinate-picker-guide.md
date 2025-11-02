# Coordinate Picker Tool - User Guide

## What It Does

The coordinate picker tool lets you click anywhere on your screen to capture and save the X, Y coordinates. This is useful for setting up automation hotkeys.

---

## How to Use

### Step 1: Run the Script
1. Double-click `coordinate-picker.ahk` to run it
2. You'll see a tooltip saying "Coordinate Picker Active!"

### Step 2: Click to Capture Coordinates
1. **Left-click** anywhere on the screen
2. A tooltip will appear showing:
   - X coordinate
   - Y coordinate
   - Color at that location
   - RGB values
3. You'll hear a beep confirming the capture

### Step 3: Check the Log File
1. All coordinates are saved to `coordinates-log.txt` in the same folder
2. Each entry includes:
   - Timestamp
   - X and Y coordinates
   - Color information

### Step 4: Exit
- Press **ESC** to close the tool

---

## Example Log Entry

```
2025-11-02 14:30:45 | X: 310 | Y: 982 | Color: 16777215 | RGB: 255,255,255
```

---

## Tips

- Click on the **exact spot** you want to automate
- You can click multiple times - all clicks are logged
- The color information helps verify you clicked the right spot
- Review `coordinates-log.txt` to see all your captured coordinates

---

## Using Coordinates in game-hotkeys.ahk

After capturing coordinates:

1. Open `coordinates-log.txt`
2. Find the X and Y values you want
3. Open `game-hotkeys.ahk` in a text editor
4. Update the coordinate values:
   ```ahk
   enterClickX := 310  ; Your X coordinate
   enterClickY := 982  ; Your Y coordinate
   ```
5. Save and run `game-hotkeys.ahk`

---

## Hotkeys

| Key | Action |
|-----|--------|
| **Left Click** | Capture coordinates at mouse position |
| **ESC** | Exit the tool |

---

## Troubleshooting

**Problem:** Script won't run
- **Solution:** Make sure AutoHotkey is installed

**Problem:** Coordinates not saving
- **Solution:** Check that you have write permissions in the folder

**Problem:** Wrong coordinates captured
- **Solution:** Click more carefully on the exact spot you want

