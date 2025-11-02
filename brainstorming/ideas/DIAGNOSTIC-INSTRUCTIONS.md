# Pixel Diagnostic Tool - Step-by-Step Instructions

## Goal
Figure out WHY the movement detector isn't working by testing if we can read pixels from the OSRS game window.

---

## Setup

1. **Open OSRS** and go to an area with goblins
2. **Make sure OSRS is in windowed mode** (not fullscreen)
   - Fullscreen often blocks pixel reading
   - If you're in fullscreen, press Alt+Enter or change settings
3. **Close the movement-detector.ahk** if it's running
4. **Run `pixel-diagnostic.ahk`** (double-click it)

---

## Test 1: Live Pixel Reading (Most Important!)

**What this tests:** Can AutoHotkey read pixels from the game at all?

### Steps:
1. Press **1** on your keyboard
2. You should see a tooltip appear saying "Live pixel display: ON"
3. Move your mouse slowly over different parts of the OSRS window:
   - Over a goblin
   - Over the ground
   - Over a tree
   - Over the sky

### What to look for:
- **GOOD SIGN:** The tooltip shows different color values as you move
  - Example: Moving from grass to goblin shows different RGB values
  - Colors change in real-time
  
- **BAD SIGN:** The tooltip shows the same color everywhere
  - OR the color values don't make sense (all black, all white)
  - OR the tooltip doesn't update

### What it means:
- ✅ **Colors change** = Pixel reading WORKS! Continue to Test 2
- ❌ **Colors don't change** = Game is blocking pixel reading - we need a different approach (see "Alternative Solutions" below)

---

## Test 2: Color Search

**What this tests:** Can we find a specific color in the game?

### Steps:
1. Press **1** to turn OFF live display (if it's still on)
2. Move your mouse directly over a **goblin** (try to get the brown/green body)
3. Press **2** to capture the color
4. Look at the screen for a colored square marker

### What to look for:
- **GREEN square** appears = Found exact color match ✅
- **YELLOW square** appears = Found similar color (tolerance 30) ⚠️
- **No square** + tooltip says "NOT FOUND" = Color search failed ❌

### What it means:
- ✅ **Green or Yellow marker** = Color detection works
- ❌ **Not found** = Color matching has issues

---

## Test 3: Movement Detection

**What this tests:** Can we detect when pixels change (movement)?

### Steps:
1. Position your mouse in the **center of where goblins walk around**
2. Press **3** to start monitoring
3. **Wait 5-10 seconds** while goblins move in that area
4. Watch the tooltip

### What to look for:
- **"CHANGES DETECTED!"** message appears
- You hear a **beep sound**
- A small **green dot** appears where change was detected
- The tooltip shows "Pixels changed: X"

### What it means:
- ✅ **Changes detected** = Movement detection works!
- ❌ **No changes** = Either goblins aren't moving OR detection isn't working

---

## Interpreting Results

### Scenario A: All tests pass ✅✅✅
**Problem:** Bug in the movement-detector.ahk script
**Solution:** We need to fix the script logic

### Scenario B: Test 1 passes, Tests 2 & 3 fail ✅❌❌
**Problem:** Color/movement detection logic issues
**Solution:** Adjust sensitivity, grid size, or detection method

### Scenario C: Test 1 fails ❌
**Problem:** Game is blocking pixel reading (DirectX/fullscreen)
**Solutions:**
1. Switch OSRS to **windowed mode** (not fullscreen)
2. Try **resizable mode** in OSRS settings
3. Use **image search** instead of pixel search (different approach)
4. Use **OCR** or **template matching**

### Scenario D: Test 1 passes but inconsistent ⚠️
**Problem:** Partial pixel reading (some areas work, some don't)
**Solution:** Adjust search area to avoid blocked regions

---

## Alternative Solutions (If Pixel Reading Fails)

If Test 1 fails and you can't get pixel reading to work:

### Option 1: Image Search
- Take a screenshot of a goblin
- Use `ImageSearch` to find that image on screen
- More reliable with games that block pixel reading

### Option 2: Color Clicker (Simpler)
- Go back to the basic color clicker approach
- Use the diagnostic tool to find the exact goblin color
- Click that color with high tolerance

### Option 3: Manual Coordinates
- Define specific X,Y coordinates where goblins spawn
- Click those coordinates in sequence
- Simpler but less flexible

---

## Quick Reference - Hotkeys

| Key | Function |
|-----|----------|
| **1** | Toggle live pixel display on/off |
| **2** | Capture color at mouse and search for it |
| **3** | Monitor area for pixel changes |
| **4** | Exit diagnostic tool |

---

## Tips for Best Results

1. **Use windowed mode** - Fullscreen often blocks pixel reading
2. **Don't move the mouse** during Test 3 - let it sit still
3. **Make sure goblins are actually moving** - they sometimes stand still
4. **Run as administrator** if tests fail (right-click → Run as administrator)
5. **Disable GPU acceleration** in OSRS if available (helps with pixel reading)

---

## What to Report Back

After running the tests, tell me:

1. **Test 1 result:** Did colors change when you moved the mouse? (Yes/No)
2. **Test 2 result:** Did you see a green/yellow marker? (Yes/No/Not Found)
3. **Test 3 result:** Did it detect changes? (Yes/No)
4. **OSRS mode:** Are you in windowed or fullscreen mode?
5. **Any error messages?** (Copy them if you see any)

This will tell me exactly what approach we need to take!

