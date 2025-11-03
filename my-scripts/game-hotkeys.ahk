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
; Enter = Click at 310, 982
; 7 = Click at 1796, 35
; 8 = Click at 1797, 176
; 9 = Click at 1726, 111
; 0 = Click at 1868, 102
; . (period) = Click at 1860, 160
; , (comma) = Click at 1720, 145 then 1720, 45
; End = Click at 1795, 107
; 1 = Exit script
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

; Number key click locations
key7ClickX := 1796
key7ClickY := 35

key8ClickX := 1797
key8ClickY := 176

key9ClickX := 1726
key9ClickY := 111

key0ClickX := 1868
key0ClickY := 102

; Period and Comma click locations
periodClickX := 1860
periodClickY := 160

commaClickX := 1720
commaClickY := 145

; End key click location
endClickX := 1795
endClickY := 107

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

; 7 - Click at 1796, 35
7::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %key7ClickX%, %key7ClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%key7ClickX% Y:%key7ClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; 8 - Click at 1797, 176
8::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %key8ClickX%, %key8ClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%key8ClickX% Y:%key8ClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; 9 - Click at 1726, 111
9::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %key9ClickX%, %key9ClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%key9ClickX% Y:%key9ClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; 0 - Click at 1868, 102
0::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %key0ClickX%, %key0ClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%key0ClickX% Y:%key0ClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; Period (.) - Click at 1860, 160
.::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %periodClickX%, %periodClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%periodClickX% Y:%periodClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; Comma (,) - Click at 1720, 145 then 1720, 45
,::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %commaClickX%, %commaClickY%
    Sleep, %clickDelay%
    Click, 1720, 45
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at 1720, 145 then 1720, 45, 10, 10
    SetTimer, RemoveToolTip, 500
return

; End - Click at 1795, 107
End::
    if (!hotkeysEnabled)
        return
    MouseGetPos, originalX, originalY
    Click, %endClickX%, %endClickY%
    Sleep, %clickDelay%
    MouseMove, %originalX%, %originalY%, 0
    ToolTip, Clicked at X:%endClickX% Y:%endClickY%, 10, 10
    SetTimer, RemoveToolTip, 500
return

; 1 - Exit script
1::
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

