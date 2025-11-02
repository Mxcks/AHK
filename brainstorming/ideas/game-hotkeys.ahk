; ========================================
; Game Hotkeys for OSRS
; ========================================
; Collection of hotkeys for gameplay automation
;
; SETUP:
; 1. Use coordinate-picker.ahk to find coordinates
; 2. Update the coordinates below
; 3. Run this script while playing
;
; CONTROLS:
; 5 = Enable all hotkeys
; 6 = Disable all hotkeys
; Enter = Click specific location
; F12 = Exit script
;
; ========================================

#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; ========================================
; CONFIGURATION
; ========================================

; Enter key click location
enterClickX := 310
enterClickY := 982

; Click settings
clickDelay := 50  ; Delay in ms after clicking

; Hotkey state
hotkeysEnabled := true

; ========================================
; HOTKEYS
; ========================================

; 5 - Enable all hotkeys
5::
    hotkeysEnabled := true
    ToolTip, Hotkeys ENABLED, 10, 10
    SoundBeep, 1000, 100
    SetTimer, RemoveToolTip, 1000
return

; 6 - Disable all hotkeys
6::
    hotkeysEnabled := false
    ToolTip, Hotkeys DISABLED, 10, 10
    SoundBeep, 500, 100
    SetTimer, RemoveToolTip, 1000
return

; Enter - Click specific location
Enter::
    ; Check if hotkeys are enabled
    if (!hotkeysEnabled)
        return

    ; Store current mouse position
    MouseGetPos, originalX, originalY

    ; Click the configured location
    Click, %enterClickX%, %enterClickY%

    ; Small delay
    Sleep, %clickDelay%

    ; Return mouse to original position
    MouseMove, %originalX%, %originalY%, 0

    ; Visual feedback
    ToolTip, Clicked at X:%enterClickX% Y:%enterClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; F12 - Exit script
F12::
    ToolTip, Exiting game hotkeys...
    Sleep, 500
    ExitApp
return

; ========================================
; TIMERS
; ========================================

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

; ========================================
; ADDITIONAL HOTKEYS
; ========================================
; Add more hotkeys below as needed
; Template:
;
; YourKey::
;     ; Your action here
;     Click, X, Y
; return

; ========================================
; INSTRUCTIONS
; ========================================
/*
HOW TO SET UP:

1. Run coordinate-picker.ahk
2. Click on the location you want Enter to click
3. Open coordinates-log.txt and copy the X and Y values
4. Update enterClickX and enterClickY at the top of this file
5. Run this script (game-hotkeys.ahk)
6. Press Enter to test - it should click your configured location

ADDING MORE HOTKEYS:

To add more hotkeys, copy this template:

YourKey::
    Click, X, Y
    ToolTip, Clicked at X:X Y:Y, 10, 10
    SetTimer, RemoveToolTip, 500
return

Replace:
- YourKey with the key you want (e.g., F1, F2, Space, etc.)
- X, Y with the coordinates from coordinate-picker.ahk

EXAMPLES:

F1::
    Click, 800, 600
return

F2::
    Click, 1024, 768
    Sleep, 100
    Click, 1024, 768  ; Double click
return

Space::
    Click, 500, 500
    Sleep, 50
    Click, 600, 600
    Sleep, 50
    Click, 700, 700
return
*/

