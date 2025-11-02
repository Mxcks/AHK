; ========================================
; Coordinate Picker Tool
; ========================================
; Click anywhere to capture and log coordinates
;
; CONTROLS:
; Left Click = Capture coordinates and save to log
; ESC = Exit
;
; ========================================

#SingleInstance Force
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; Log file location
logFile := A_ScriptDir . "\coordinates-log.txt"

; Show startup message
ToolTip, Coordinate Picker Active!`n`nLeft Click = Capture coordinates`nESC = Exit`n`nLog file: coordinates-log.txt, 10, 10
SetTimer, RemoveStartupTip, 3000

; ========================================
; HOTKEYS
; ========================================

; Left Click - Capture coordinates
~LButton::
    ; Wait for click to complete
    Sleep, 50

    ; Get mouse position
    MouseGetPos, clickX, clickY

    ; Get current timestamp
    FormatTime, timestamp, , yyyy-MM-dd HH:mm:ss

    ; Get pixel color at this location
    PixelGetColor, pixelColor, %clickX%, %clickY%, RGB

    ; Extract RGB components
    red := (pixelColor >> 16) & 0xFF
    green := (pixelColor >> 8) & 0xFF
    blue := pixelColor & 0xFF

    ; Append to log file
    FileAppend, %timestamp% | X: %clickX% | Y: %clickY% | Color: %pixelColor% | RGB: %red%,%green%,%blue%`n, %logFile%

    ; Show tooltip with coordinates
    ToolTip, COORDINATES CAPTURED!`n`nX: %clickX%`nY: %clickY%`n`nColor: %pixelColor%`nRGB: %red% %green% %blue%`n`nSaved to: coordinates-log.txt`n`nClick again or press ESC to exit, 10, 10

    ; Beep to confirm
    SoundBeep, 1500, 100

    ; Auto-hide tooltip after 3 seconds
    SetTimer, RemoveToolTip, 3000
return

; ESC - Exit
Esc::
    ToolTip, Coordinate Picker closed.`n`nCheck coordinates-log.txt for saved coordinates.
    Sleep, 1000
    ExitApp
return

; ========================================
; TIMERS
; ========================================

RemoveStartupTip:
    SetTimer, RemoveStartupTip, Off
    ToolTip
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

; ========================================
; INSTRUCTIONS
; ========================================
/*
HOW TO USE:

1. Run this script (coordinate-picker.ahk)
2. Click anywhere on the screen to capture coordinates
3. The coordinates will be:
   - Displayed in a tooltip
   - Saved to coordinates-log.txt
   - Logged with timestamp and color information

4. Use the captured coordinates in your game-hotkeys.ahk file

EXAMPLE LOG ENTRY:
2025-11-02 14:30:45 | X: 1024 | Y: 768 | Color: 16777215 | RGB: 255,255,255

TIPS:
- Click on the exact spot you want to automate
- The color information helps verify you clicked the right spot
- All clicks are logged, so you can review them later
- Press ESC to exit when done
*/

