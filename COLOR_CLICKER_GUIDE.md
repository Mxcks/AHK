# Color Clicker Guide

This guide will help you create and use a color-based auto-clicker in AutoHotkey. Color clickers detect specific pixel colors on your screen and automatically click when that color is found.

## What is a Color Clicker?

A color clicker is a script that:
1. Searches for a specific color at a screen location
2. Clicks automatically when that color is detected
3. Can be used for automation tasks, gaming, or repetitive clicking

---

## Step One: Install AutoHotkey

If you haven't already installed AutoHotkey:
1. Run `AutoHotkey_1.1.37.02_setup.exe` in this folder
2. Follow the installation wizard
3. Verify installation by right-clicking any `.ahk` file - you should see "Run Script" option

---

## Step Two: Find the Target Color

You need to identify the exact color you want to click on:

1. **Download a color picker tool** (or use AutoHotkey's built-in Window Spy):
   - Press `Win + R`, type `AU3_Spy.exe`, and press Enter (comes with AHK)
   - Or download a tool like "Just Color Picker"

2. **Hover over the target area** on your screen where you want to detect the color

3. **Note the color value** in hexadecimal format (e.g., `0xFF0000` for red)
   - In Window Spy, look for "Color" under the mouse position section

4. **Note the coordinates** (X, Y position) where you want to search for the color

---

## Step Three: Create Your Color Clicker Script

1. **Create a new file** in the `my-scripts/in-progress/` folder
   - Right-click → New → AutoHotkey Script
   - Name it something like `color-clicker.ahk`

2. **Open the file** in a text editor (Notepad, VS Code, etc.)

3. **Copy this basic template**:

```ahk
; Color Clicker Script
; Press F1 to start/stop the clicker

#SingleInstance Force
SetBatchLines, -1

toggle := false

F1::
    toggle := !toggle
    if (toggle) {
        SetTimer, CheckColor, 100  ; Check every 100ms
        ToolTip, Color Clicker: ON
    } else {
        SetTimer, CheckColor, Off
        ToolTip, Color Clicker: OFF
    }
    SetTimer, RemoveToolTip, 2000
return

CheckColor:
    ; Replace these values with your target color and coordinates
    targetColor := 0xFF0000  ; Red color (change this)
    searchX := 500           ; X coordinate (change this)
    searchY := 300           ; Y coordinate (change this)
    
    PixelGetColor, currentColor, %searchX%, %searchY%, RGB
    
    if (currentColor = targetColor) {
        Click, %searchX%, %searchY%
        Sleep, 50  ; Small delay after clicking
    }
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

F2::ExitApp  ; Press F2 to exit the script
```

---

## Step Four: Customize the Script

Edit these values in your script:

1. **`targetColor`** - Replace `0xFF0000` with your color from Step Two
   - Format: `0x` followed by the hex color code

2. **`searchX` and `searchY`** - Replace with the coordinates from Step Two
   - These are the pixel coordinates where the script will look for the color

3. **Check interval** - Adjust `100` in `SetTimer, CheckColor, 100`
   - Lower = faster checking (more CPU usage)
   - Higher = slower checking (less CPU usage)

4. **Hotkeys** (optional):
   - Change `F1::` to use a different key to toggle on/off
   - Change `F2::` to use a different exit key

---

## Step Five: Test Your Script

1. **Save your script** (Ctrl + S)

2. **Double-click the `.ahk` file** to run it

3. **Press F1** to activate the color clicker
   - You should see a tooltip saying "Color Clicker: ON"

4. **Test the detection**:
   - Open the application/window with your target color
   - Position it so the color appears at your specified coordinates
   - The script should click automatically when it detects the color

5. **Press F1 again** to stop the clicker

6. **Press F2** to exit the script completely

---

## Step Six: Refine and Debug

If the clicker isn't working:

1. **Verify the color value**:
   - Colors can change based on lighting, themes, or window states
   - Use Window Spy to double-check the color while the script is running

2. **Check coordinates**:
   - Make sure the window is in the same position when you run the script
   - Consider using `PixelSearch` instead of fixed coordinates for more flexibility

3. **Add color tolerance** (for slight color variations):
```ahk
PixelSearch, foundX, foundY, %searchX%-5, %searchY%-5, %searchX%+5, %searchY%+5, %targetColor%, 3, Fast RGB
if (!ErrorLevel) {
    Click, %foundX%, %foundY%
}
```

4. **Add debugging** to see what's happening:
```ahk
ToolTip, Current: %currentColor% | Target: %targetColor%
```

---

## Step Seven: Move to Completed (When Ready)

Once your color clicker works perfectly:

1. **Test thoroughly** in different scenarios
2. **Add comments** explaining what the script does
3. **Move the file** from `my-scripts/in-progress/` to `my-scripts/completed/`
4. **Document any special requirements** (screen resolution, specific applications, etc.)

---

## Advanced Tips

- **Search in a region** instead of a single pixel using `PixelSearch`
- **Add multiple color targets** with different actions
- **Use `CoordMode, Pixel, Screen`** for absolute screen coordinates
- **Add safety features** like automatic shutoff after X clicks
- **Combine with image search** for more complex automation

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Script doesn't click | Verify color and coordinates are correct |
| Clicks too fast/slow | Adjust the timer interval (100ms default) |
| Wrong location clicked | Double-check X, Y coordinates |
| Color not detected | Add color tolerance or use PixelSearch |
| Script won't stop | Press F2 to force exit |

---

## Safety Reminders

- Always test scripts in safe environments first
- Be aware of game/application terms of service regarding automation
- Use reasonable delays to avoid system overload
- Keep an exit hotkey (F2) easily accessible

---

**Happy Automating! 🚀**

