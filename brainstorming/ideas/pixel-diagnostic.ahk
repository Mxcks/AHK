; ========================================
; Pixel Reading Diagnostic Tool
; ========================================
; This tool helps diagnose why movement/color detection isn't working
;
; CONTROLS:
; 1 = Toggle live pixel color display (shows color under mouse)
; 2 = Capture color at mouse position and search for it
; 3 = Test pixel reading in a small area (detect any changes)
; 4 = Exit
;
; ========================================

#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; Variables
liveDisplay := false
testingArea := false
capturedColor := ""
lastColors := []

; ========================================
; HOTKEYS
; ========================================

; 1 - Toggle live pixel display
1::
    liveDisplay := !liveDisplay
    
    if (liveDisplay) {
        SetTimer, ShowLivePixel, 50
        ToolTip, Live pixel display: ON, 10, 10
        SoundBeep, 1000, 100
    } else {
        SetTimer, ShowLivePixel, Off
        ToolTip, Live pixel display: OFF, 10, 10
        SoundBeep, 500, 100
        Sleep, 1000
        ToolTip
    }
return

; 2 - Capture color and search
2::
    MouseGetPos, mouseX, mouseY
    PixelGetColor, capturedColor, %mouseX%, %mouseY%, RGB

    ToolTip, Captured color at X:%mouseX% Y:%mouseY%`nColor: %capturedColor%`n`nSearching for this color in 200x200 area..., 10, 10
    SoundBeep, 1200, 200
    
    ; Search in a 200x200 area around the click
    searchX1 := mouseX - 100
    searchY1 := mouseY - 100
    searchX2 := mouseX + 100
    searchY2 := mouseY + 100
    
    ; Search for exact color
    PixelSearch, foundX, foundY, %searchX1%, %searchY1%, %searchX2%, %searchY2%, %capturedColor%, 0, Fast RGB

    if (ErrorLevel = 0) {
        ToolTip, SUCCESS! Found exact color at X:%foundX% Y:%foundY%`nOriginal: X:%mouseX% Y:%mouseY%`nColor: %capturedColor%, 10, 10
        
        ; Draw marker
        Gui, FoundMarker:Destroy
        Gui, FoundMarker:+AlwaysOnTop +ToolWindow -Caption +LastFound
        Gui, FoundMarker:Color, Lime
        markerX := foundX - 10
        markerY := foundY - 10
        Gui, FoundMarker:Show, x%markerX% y%markerY% w20 h20 NoActivate
        SetTimer, HideFoundMarker, 3000
    } else {
        ; Try with tolerance
        PixelSearch, foundX, foundY, %searchX1%, %searchY1%, %searchX2%, %searchY2%, %capturedColor%, 30, Fast RGB

        if (ErrorLevel = 0) {
            ToolTip, Found similar color (tolerance 30) at X:%foundX% Y:%foundY%`nOriginal: X:%mouseX% Y:%mouseY%`nColor: %capturedColor%, 10, 10
            
            ; Draw marker
            Gui, FoundMarker:Destroy
            Gui, FoundMarker:+AlwaysOnTop +ToolWindow -Caption +LastFound
            Gui, FoundMarker:Color, Yellow
            markerX := foundX - 10
            markerY := foundY - 10
            Gui, FoundMarker:Show, x%markerX% y%markerY% w20 h20 NoActivate
            SetTimer, HideFoundMarker, 3000
        } else {
            ToolTip, NOT FOUND! Color %capturedColor% not found in 200x200 area`nThis might mean the game is blocking pixel reading!, 10, 10
        }
    }
    
    SetTimer, RemoveToolTip, 5000
return

; 3 - Test area for any pixel changes
3::
    testingArea := !testingArea
    
    if (testingArea) {
        MouseGetPos, testCenterX, testCenterY
        testX1 := testCenterX - 50
        testY1 := testCenterY - 50
        testX2 := testCenterX + 50
        testY2 := testCenterY + 50
        
        ToolTip, Testing 100x100 area centered at X:%testCenterX% Y:%testCenterY%`nWatching for ANY pixel changes..., 10, 10
        SetTimer, TestAreaChanges, 100
        SoundBeep, 1000, 150
    } else {
        SetTimer, TestAreaChanges, Off
        ToolTip, Area testing stopped, 10, 10
        SoundBeep, 500, 150
        Sleep, 1000
        ToolTip
    }
return

; 4 - Exit
4::
    ToolTip, Exiting diagnostic tool...
    Sleep, 500
    ExitApp
return

; ========================================
; FUNCTIONS
; ========================================

ShowLivePixel:
    if (!liveDisplay)
        return

    MouseGetPos, mouseX, mouseY
    PixelGetColor, currentColor, %mouseX%, %mouseY%, RGB

    ; Extract RGB components
    red := (currentColor >> 16) & 0xFF
    green := (currentColor >> 8) & 0xFF
    blue := currentColor & 0xFF

    ToolTip, LIVE PIXEL READER`n`nPosition: X:%mouseX% Y:%mouseY%`nColor: %currentColor%`nRGB: R:%red% G:%green% B:%blue%`n`nPress 1 to stop, 10, 10
return

TestAreaChanges:
    global testingArea, testX1, testY1, testX2, testY2
    static firstRun := true
    changesDetected := 0
    totalPixels := 0

    if (!testingArea)
        return

    if (firstRun) {
        ; Take initial snapshot
        Loop {
            x := testX1 + (A_Index - 1) * 10
            if (x > testX2)
                break

            Loop {
                y := testY1 + (A_Index - 1) * 10
                if (y > testY2)
                    break

                PixelGetColor, color, %x%, %y%, RGB
                key := x "_" y
                snapshot_%key% := color
                totalPixels++
            }
        }
        firstRun := false
        ToolTip, Initial snapshot taken (%totalPixels% pixels)`nWatching for changes..., 10, 10
        return
    }

    ; Compare with snapshot
    Loop {
        x := testX1 + (A_Index - 1) * 10
        if (x > testX2)
            break

        Loop {
            y := testY1 + (A_Index - 1) * 10
            if (y > testY2)
                break

            PixelGetColor, currentColor, %x%, %y%, RGB
            key := x "_" y
            oldColor := snapshot_%key%

            diff := Abs(currentColor - oldColor)

            if (diff > 10) {
                changesDetected++

                ; Update snapshot with new color
                snapshot_%key% := currentColor

                ; Show where change was detected
                if (changesDetected = 1) {
                    firstChangeX := x
                    firstChangeY := y
                }
            }
        }
    }

    if (changesDetected > 0) {
        ToolTip, CHANGES DETECTED!`nPixels changed: %changesDetected%`nFirst change at: X:%firstChangeX% Y:%firstChangeY%`n`nThis means pixel reading WORKS!`nPress 3 to stop, 10, 10
        SoundBeep, 1500, 50

        ; Draw marker at first change
        Gui, ChangeMarker:Destroy
        Gui, ChangeMarker:+AlwaysOnTop +ToolWindow -Caption +LastFound
        Gui, ChangeMarker:Color, Lime
        markerX := firstChangeX - 5
        markerY := firstChangeY - 5
        Gui, ChangeMarker:Show, x%markerX% y%markerY% w10 h10 NoActivate
    } else {
        ToolTip, Watching for changes...`nNo changes detected yet`nPixels monitored: %totalPixels%`n`nPress 3 to stop, 10, 10
    }
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

HideFoundMarker:
    SetTimer, HideFoundMarker, Off
    Gui, FoundMarker:Destroy
return

; ========================================
; INSTRUCTIONS
; ========================================
/*
PIXEL DIAGNOSTIC TOOL - HOW TO USE:

This tool helps figure out WHY detection isn't working.

TEST 1: Can we read pixels from the game?
1. Press 1 to turn on live pixel display
2. Move your mouse over the game window
3. Watch the tooltip - does it show changing colors?
   - YES = Pixel reading works! Problem is elsewhere
   - NO = Game might be blocking pixel reading (DirectX/fullscreen issue)

TEST 2: Can we find a specific color?
1. Move mouse over a goblin
2. Press 2 to capture the color and search for it
3. Look for the green/yellow marker
   - GREEN marker = Found exact color match
   - YELLOW marker = Found similar color (tolerance 30)
   - "NOT FOUND" = Color search isn't working

TEST 3: Can we detect ANY changes?
1. Move mouse to center of where goblins are
2. Press 3 to start monitoring that area
3. Wait and watch - does it detect changes when goblins move?
   - "CHANGES DETECTED" + beep = Movement detection works!
   - "No changes detected" = Either nothing is moving OR pixel reading blocked

WHAT TO DO NEXT:
- If TEST 1 fails: Game is blocking pixel reading - need different approach
- If TEST 1 works but TEST 2 fails: Color matching issue
- If TEST 1 & 2 work but TEST 3 fails: Movement detection logic issue
- If all tests work: Original script has a bug we need to fix

Press 4 to exit this tool.
*/

