; ========================================
; OSRS Goblin Auto-Clicker
; ========================================
; Description: Automatically clicks on goblins in Old School RuneScape
; Uses color detection to find goblins and clicks them with a delay
;
; CONTROLS:
; 1 = Start/Stop the goblin clicker
; 2 = Exit script completely
; 3 = Show current mouse position and color (for setup/debugging)
; 4 = Mark search area (click 4, then click top-left, then bottom-right of search area)
;
; ========================================

#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; ========================================
; CONFIGURATION - ADJUST THESE VALUES
; ========================================

; Goblin color (change this after testing)
; Common goblin colors in OSRS:
; Brown goblins: 0x8B4513 or similar brown shades
; Green goblins: 0x228B22 or similar green shades
goblinColor := 0x8B4513  ; Default: Brown color

; Color tolerance (0-255, higher = more lenient matching)
; Increase if the script misses goblins, decrease if it clicks wrong things
colorTolerance := 30

; Search area (where to look for goblins on screen)
; Default: center area of screen - adjust after using F4 to mark your area
searchX1 := 400   ; Left edge
searchY1 := 200   ; Top edge
searchX2 := 1200  ; Right edge
searchY2 := 800   ; Bottom edge

; Time to wait after clicking a goblin (in milliseconds)
; 15 seconds = 15000 ms
killDelay := 15000

; Click offset (pixels to offset from found color, useful for clicking center of goblin)
clickOffsetX := 0
clickOffsetY := 0

; ========================================
; SCRIPT VARIABLES (Don't change these)
; ========================================

scriptActive := false
debugMode := false
markingArea := 0
tempX1 := 0
tempY1 := 0

; ========================================
; HOTKEYS
; ========================================

; 1 - Toggle goblin clicker on/off
1::
    scriptActive := !scriptActive
    if (scriptActive) {
        SetTimer, FindAndClickGoblin, 100
        SoundBeep, 1000, 200
        ToolTip, Goblin Clicker: ACTIVE, 10, 10
        SetTimer, RemoveToolTip, 2000
    } else {
        SetTimer, FindAndClickGoblin, Off
        SoundBeep, 500, 200
        ToolTip, Goblin Clicker: STOPPED, 10, 10
        SetTimer, RemoveToolTip, 2000
    }
return

; 2 - Exit script
2::
    ToolTip, Exiting Goblin Clicker...
    Sleep, 500
    ExitApp
return

; 3 - Debug mode: Show mouse position and color
3::
    debugMode := !debugMode
    if (debugMode) {
        SetTimer, ShowMouseInfo, 100
        ToolTip, Debug Mode: ON (showing mouse info), 10, 10
    } else {
        SetTimer, ShowMouseInfo, Off
        ToolTip, Debug Mode: OFF, 10, 10
        SetTimer, RemoveToolTip, 2000
    }
return

; 4 - Mark search area
4::
    if (markingArea = 0) {
        markingArea := 1
        ToolTip, Click the TOP-LEFT corner of your search area, 10, 10
    } else if (markingArea = 1) {
        MouseGetPos, tempX1, tempY1
        markingArea := 2
        ToolTip, Top-left marked! Now click the BOTTOM-RIGHT corner, 10, 10
    } else if (markingArea = 2) {
        MouseGetPos, tempX2, tempY2
        searchX1 := tempX1
        searchY1 := tempY1
        searchX2 := tempX2
        searchY2 := tempY2
        markingArea := 0
        ToolTip, Search area set! X1:%searchX1% Y1:%searchY1% X2:%searchX2% Y2:%searchY2%, 10, 10
        SetTimer, RemoveToolTip, 3000
        
        ; Draw a box to show the search area
        Gui, SearchBox:Destroy
        Gui, SearchBox:+AlwaysOnTop +ToolWindow -Caption +LastFound
        Gui, SearchBox:Color, Red
        WinSet, TransColor, Red 150
        boxWidth := searchX2 - searchX1
        boxHeight := searchY2 - searchY1
        Gui, SearchBox:Show, x%searchX1% y%searchY1% w%boxWidth% h%boxHeight% NoActivate
        SetTimer, HideSearchBox, 3000
    }
return

; ========================================
; MAIN FUNCTIONS
; ========================================

FindAndClickGoblin:
    if (!scriptActive)
        return
    
    ; Search for the goblin color in the defined area
    PixelSearch, foundX, foundY, searchX1, searchY1, searchX2, searchY2, goblinColor, colorTolerance, Fast RGB
    
    if (ErrorLevel = 0) {
        ; Goblin found! Click it
        clickX := foundX + clickOffsetX
        clickY := foundY + clickOffsetY
        
        ; Visual feedback
        ToolTip, Goblin found! Clicking at X:%clickX% Y:%clickY%, 10, 10
        
        ; Click the goblin
        Click, %clickX%, %clickY%
        
        ; Wait for kill to complete
        Sleep, %killDelay%
        
        ; Clear tooltip
        ToolTip
        
    } else {
        ; No goblin found - keep searching
        ToolTip, Searching for goblins..., 10, 10
    }
return

ShowMouseInfo:
    MouseGetPos, mouseX, mouseY
    PixelGetColor, currentColor, %mouseX%, %mouseY%, RGB

    ; Convert color to hex for display
    colorHex := Format("0x{:06X}", currentColor)

    ToolTip, X: %mouseX% | Y: %mouseY% | Color: %colorHex%`nPress 3 to disable debug mode, 10, 10
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

HideSearchBox:
    SetTimer, HideSearchBox, Off
    Gui, SearchBox:Destroy
return

; ========================================
; SETUP INSTRUCTIONS
; ========================================
/*
HOW TO SET UP THIS SCRIPT:

1. FIND THE GOBLIN COLOR:
   - Run this script
   - Press 3 to enable debug mode
   - Hover your mouse over a goblin in OSRS
   - Note the color value shown (e.g., 0x8B4513)
   - Press 3 to disable debug mode
   - Edit this script and change "goblinColor" to the color you found

2. SET THE SEARCH AREA:
   - Press 4
   - Click the top-left corner of where goblins appear
   - Click the bottom-right corner of where goblins appear
   - A red box will briefly show your search area
   - The coordinates are saved automatically

3. TEST THE SCRIPT:
   - Make sure OSRS is open and visible
   - Stand near goblins
   - Press 1 to start the clicker
   - Watch it find and click goblins
   - Press 1 to stop if needed

4. ADJUST IF NEEDED:
   - If it clicks trees/ground: Decrease colorTolerance or refine the color
   - If it misses goblins: Increase colorTolerance
   - If it clicks too early/late: Adjust killDelay
   - If it clicks the wrong part of goblin: Adjust clickOffsetX/Y

5. SAFETY:
   - Always monitor the script while running
   - Use at your own risk (check OSRS rules)
   - Press 2 to exit immediately if needed

TIPS:
- Test in a safe area first
- Start with a small search area to avoid clicking wrong things
- Goblins in different areas might have slightly different colors
- The script works best when OSRS is in fixed screen mode
*/

