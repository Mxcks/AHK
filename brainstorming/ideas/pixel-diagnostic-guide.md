# Pixel Diagnostic Tool - User Guide

## What It Does

This tool helps diagnose why pixel-based detection (like the movement detector) isn't working. It tests whether AutoHotkey can read pixels from your game window.

---

## How to Use

### Step 1: Prepare Your Game
1. **Open OSRS** (or your game)
2. **Switch to windowed mode** (not fullscreen)
   - Fullscreen often blocks pixel reading
   - Press Alt+Enter or change in game settings
3. Position the game window where you want it

### Step 2: Run the Diagnostic Tool
1. Double-click `pixel-diagnostic.ahk` to run it
2. You'll see a tooltip with instructions

---

## The Three Tests

### Test 1: Live Pixel Reading
**What it tests:** Can AutoHotkey read pixels from the game?

1. Press **1** on your keyboard
2. Move your mouse over different parts of the game:
   - Over a goblin
   - Over the ground
   - Over a tree
3. Watch the tooltip - does it show changing colors?

**Good Result:** Colors change as you move the mouse ✅  
**Bad Result:** Colors stay the same or don't make sense ❌

---

### Test 2: Color Search
**What it tests:** Can we find a specific color?

1. Press **1** to turn off live display (if still on)
2. Move your mouse over a goblin
3. Press **2** to capture the color
4. Look for a colored square marker:
   - **Green square** = Found exact color ✅
   - **Yellow square** = Found similar color ⚠️
   - **No square** = Color not found ❌

---

### Test 3: Movement Detection
**What it tests:** Can we detect when pixels change?

1. Move your mouse to the center of where goblins walk
2. Press **3** to start monitoring
3. Wait 5-10 seconds while goblins move
4. Watch for:
   - "CHANGES DETECTED!" message
   - Beep sound
   - Green dot where movement was detected

**Good Result:** Changes detected with beeps ✅  
**Bad Result:** No changes detected ❌

---

## Hotkeys

| Key | Action |
|-----|--------|
| **1** | Toggle live pixel display on/off |
| **2** | Capture color at mouse and search for it |
| **3** | Monitor area for pixel changes (movement) |
| **4** | Exit diagnostic tool |

---

## What the Results Mean

### All Tests Pass ✅✅✅
- Pixel reading works!
- Problem is in the movement-detector script logic
- We can fix the script

### Test 1 Passes, Tests 2 & 3 Fail ✅❌❌
- Pixel reading works but detection logic has issues
- Need to adjust sensitivity or detection method

### Test 1 Fails ❌
- Game is blocking pixel reading
- **Solutions:**
  - Switch to windowed mode (not fullscreen)
  - Try resizable mode in game settings
  - Use image search instead of pixel search
  - Run script as administrator

---

## Tips for Best Results

1. **Always use windowed mode** - Fullscreen blocks pixel reading
2. **Don't move the mouse** during Test 3
3. **Make sure things are actually moving** in the test area
4. **Try running as administrator** if tests fail (right-click script → Run as administrator)

---

## Troubleshooting

**Problem:** Test 1 shows same color everywhere
- **Solution:** Game is in fullscreen mode - switch to windowed

**Problem:** Test 2 can't find colors
- **Solution:** Increase tolerance or try different colors

**Problem:** Test 3 doesn't detect movement
- **Solution:** Make sure goblins are actually moving in the area, or try a larger area

**Problem:** Script has errors
- **Solution:** Make sure you're using AutoHotkey v1.1 (not v2)

