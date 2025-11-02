; ========================================
; Movement Detection Auto-Clicker
; ========================================
; Description: Detects moving objects (like goblins) and clicks on them
; Works by comparing pixel snapshots to detect changes (movement)
;
; CONTROLS:
; 1 = Start/Stop movement detection and clicking
; 2 = Exit script completely
; 3 = Test mode - Show detected movement without clicking
; 4 = Mark search area (click 4, then click top-left, then bottom-right)
; 5 = Adjust sensitivity (cycles through low/medium/high)
; 6 = Toggle showing search area box (to verify size)
;
; ========================================

#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; ========================================
; CONFIGURATION - ADJUST THESE VALUES
; ========================================

; Search area (where to look for movement)
searchX1 := 400
searchY1 := 200
searchX2 := 1200
searchY2 := 800

; Grid size - how many points to check for movement
; Higher = more accurate but slower
; Lower = faster but might miss small movements
gridSize := 20  ; Check every 20 pixels

; Movement detection delay (milliseconds between snapshots)
; Lower = detects faster movement, Higher = detects slower movement
detectionDelay := 100

; Sensitivity - how different pixels must be to count as movement
; Low = 10 (very sensitive, might detect small changes)
; Medium = 30 (balanced)
; High = 50 (only detects obvious movement)
sensitivity := 30

; Time to wait after clicking (milliseconds)
clickDelay := 15000  ; 15 seconds

; Minimum movement points needed to count as a valid target
; Higher = more strict (needs more pixels changing)
; Lower = less strict (fewer pixels changing is OK)
minMovementPoints := 3

; ========================================
; SCRIPT VARIABLES
; ========================================

scriptActive := false
testMode := false
markingArea := 0
tempX1 := 0
tempY1 := 0
movementCount := 0
sensitivityLevel := "Medium"
showSearchBox := false

; ========================================
; HOTKEYS
; ========================================

; 1 - Toggle movement clicker on/off
1::
    scriptActive := !scriptActive
    testMode := false
    if (scriptActive) {
        SetTimer, DetectAndClick, 100
        SoundBeep, 1000, 200
        ToolTip, Movement Clicker: ACTIVE (Will Click), 10, 10
        SetTimer, RemoveToolTip, 2000
    } else {
        SetTimer, DetectAndClick, Off
        SoundBeep, 500, 200
        ToolTip, Movement Clicker: STOPPED, 10, 10
        SetTimer, RemoveToolTip, 2000
    }
return

; 2 - Exit script
2::
    ToolTip, Exiting Movement Detector...
    Sleep, 500
    ExitApp
return

; 3 - Test mode (show movement without clicking)
3::
    testMode := !testMode
    scriptActive := false
    SetTimer, DetectAndClick, Off
    
    if (testMode) {
        SetTimer, DetectMovementTest, 100
        SoundBeep, 800, 150
        ToolTip, Test Mode: ON (Showing movement only), 10, 10
        SetTimer, RemoveToolTip, 2000
    } else {
        SetTimer, DetectMovementTest, Off
        SoundBeep, 600, 150
        ToolTip, Test Mode: OFF, 10, 10
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
        ToolTip, Top-left marked at X:%tempX1% Y:%tempY1%`nNow click the BOTTOM-RIGHT corner, 10, 10
    } else if (markingArea = 2) {
        MouseGetPos, tempX2, tempY2
        searchX1 := tempX1
        searchY1 := tempY1
        searchX2 := tempX2
        searchY2 := tempY2
        markingArea := 0

        boxWidth := searchX2 - searchX1
        boxHeight := searchY2 - searchY1
        ToolTip, Search area set!`nTop-Left: X:%searchX1% Y:%searchY1%`nBottom-Right: X:%searchX2% Y:%searchY2%`nSize: %boxWidth%x%boxHeight% pixels, 10, 10
        SetTimer, RemoveToolTip, 4000

        ; Draw corner markers to show the search area
        Gosub, ShowSearchAreaMarkers
        SetTimer, HideSearchBox, 4000
    }
return

; 5 - Adjust sensitivity
5::
    if (sensitivityLevel = "Low") {
        sensitivity := 30
        sensitivityLevel := "Medium"
    } else if (sensitivityLevel = "Medium") {
        sensitivity := 50
        sensitivityLevel := "High"
    } else {
        sensitivity := 10
        sensitivityLevel := "Low"
    }
    ToolTip, Sensitivity: %sensitivityLevel% (%sensitivity%), 10, 10
    SetTimer, RemoveToolTip, 2000
return

; 6 - Toggle showing search area box
6::
    showSearchBox := !showSearchBox

    if (showSearchBox) {
        ; Show the search area markers
        boxWidth := searchX2 - searchX1
        boxHeight := searchY2 - searchY1
        Gosub, ShowSearchAreaMarkers
        ToolTip, Search area markers: VISIBLE | Area: %boxWidth%x%boxHeight% pixels, 10, 10
        SetTimer, RemoveToolTip, 2000
    } else {
        ; Hide the search area markers
        Gosub, HideSearchAreaMarkers
        ToolTip, Search area markers: HIDDEN, 10, 10
        SetTimer, RemoveToolTip, 2000
    }
return

; ========================================
; MAIN FUNCTIONS
; ========================================

DetectAndClick:
    if (!scriptActive)
        return

    DetectMovement(foundMovement, foundX, foundY)

    if (foundMovement) {
        ; Movement detected! Click it
        ToolTip, Movement detected! Clicking at X:%foundX% Y:%foundY% | Count: %movementCount%, 10, 10

        Click, %foundX%, %foundY%

        ; Wait for kill to complete
        Sleep, %clickDelay%

        ToolTip
    } else {
        ToolTip, Searching for movement... | Sensitivity: %sensitivityLevel%, 10, 10
    }
return

DetectMovementTest:
    if (!testMode)
        return

    DetectMovement(foundMovement, foundX, foundY)

    if (foundMovement) {
        ToolTip, TEST MODE: Movement detected!`nLocation: X:%foundX% Y:%foundY%`nMoving pixels: %movementCount%`nSensitivity: %sensitivityLevel%, 10, 10

        ; Draw a bright red marker where movement was detected
        Gui, MovementMarker:Destroy
        Gui, MovementMarker:+AlwaysOnTop +ToolWindow -Caption +LastFound
        Gui, MovementMarker:Color, Red
        markerX := foundX - 15
        markerY := foundY - 15
        Gui, MovementMarker:Show, x%markerX% y%markerY% w30 h30 NoActivate

        ; Also beep to indicate detection
        SoundBeep, 1500, 100

        SetTimer, HideMovementMarker, 1500
    } else {
        ToolTip, TEST MODE: Scanning...`nMoving pixels found: %movementCount%`nSensitivity: %sensitivityLevel%`nSearch area: %searchX1%,%searchY1% to %searchX2%,%searchY2%, 10, 10
    }
return

DetectMovement(ByRef found, ByRef outX, ByRef outY) {
    global searchX1, searchY1, searchX2, searchY2, gridSize, detectionDelay, sensitivity, minMovementPoints, movementCount

    movementPointsX := []
    movementPointsY := []
    movementCount := 0

    ; Take first snapshot
    Loop {
        x := searchX1 + (A_Index - 1) * gridSize
        if (x > searchX2)
            break

        Loop {
            y := searchY1 + (A_Index - 1) * gridSize
            if (y > searchY2)
                break

            PixelGetColor, color1, %x%, %y%, RGB

            ; Store the color
            key := x "_" y
            snapshot1_%key% := color1
        }
    }

    ; Wait a moment
    Sleep, %detectionDelay%

    ; Take second snapshot and compare
    Loop {
        x := searchX1 + (A_Index - 1) * gridSize
        if (x > searchX2)
            break

        Loop {
            y := searchY1 + (A_Index - 1) * gridSize
            if (y > searchY2)
                break

            PixelGetColor, color2, %x%, %y%, RGB

            ; Compare with first snapshot
            key := x "_" y
            color1 := snapshot1_%key%

            ; Calculate color difference
            diff := Abs(color1 - color2)

            if (diff > sensitivity) {
                ; Movement detected at this point!
                movementPointsX.Push(x)
                movementPointsY.Push(y)
                movementCount++
            }
        }
    }

    ; If we found enough movement points, return the first one
    if (movementPointsX.Length() >= minMovementPoints) {
        found := true
        outX := movementPointsX[1]
        outY := movementPointsY[1]
    } else {
        found := false
        outX := 0
        outY := 0
    }
}

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

ShowSearchAreaMarkers:
    ; Destroy old markers
    Gui, CornerTL:Destroy
    Gui, CornerTR:Destroy
    Gui, CornerBL:Destroy
    Gui, CornerBR:Destroy

    markerSize := 30

    ; Top-left corner
    Gui, CornerTL:+AlwaysOnTop +ToolWindow -Caption +LastFound
    Gui, CornerTL:Color, Red
    Gui, CornerTL:Show, x%searchX1% y%searchY1% w%markerSize% h%markerSize% NoActivate

    ; Top-right corner
    cornerTRX := searchX2 - markerSize
    Gui, CornerTR:+AlwaysOnTop +ToolWindow -Caption +LastFound
    Gui, CornerTR:Color, Red
    Gui, CornerTR:Show, x%cornerTRX% y%searchY1% w%markerSize% h%markerSize% NoActivate

    ; Bottom-left corner
    cornerBLY := searchY2 - markerSize
    Gui, CornerBL:+AlwaysOnTop +ToolWindow -Caption +LastFound
    Gui, CornerBL:Color, Red
    Gui, CornerBL:Show, x%searchX1% y%cornerBLY% w%markerSize% h%markerSize% NoActivate

    ; Bottom-right corner
    cornerBRX := searchX2 - markerSize
    cornerBRY := searchY2 - markerSize
    Gui, CornerBR:+AlwaysOnTop +ToolWindow -Caption +LastFound
    Gui, CornerBR:Color, Red
    Gui, CornerBR:Show, x%cornerBRX% y%cornerBRY% w%markerSize% h%markerSize% NoActivate
return

HideSearchAreaMarkers:
    Gui, CornerTL:Destroy
    Gui, CornerTR:Destroy
    Gui, CornerBL:Destroy
    Gui, CornerBR:Destroy
return

HideSearchBox:
    SetTimer, HideSearchBox, Off
    ; Only hide if not in persistent show mode
    if (!showSearchBox) {
        Gosub, HideSearchAreaMarkers
    }
return

HideMovementMarker:
    SetTimer, HideMovementMarker, Off
    Gui, MovementMarker:Destroy
return

; ========================================
; SETUP INSTRUCTIONS
; ========================================
/*
HOW TO USE THIS SCRIPT:

1. SET UP YOUR SEARCH AREA:
   - Press 4
   - Click the top-left corner where goblins spawn
   - Click the bottom-right corner where goblins spawn
   - A blue box will briefly show your search area
   - Press 6 to toggle the box on/off to verify the size

2. TEST MOVEMENT DETECTION:
   - Press 3 to enter test mode
   - Watch for red markers where movement is detected
   - Check if it's detecting goblins correctly
   - Press 3 again to stop test mode

3. ADJUST SENSITIVITY IF NEEDED:
   - Press 5 to cycle through Low/Medium/High sensitivity
   - Low = detects small movements (might be too sensitive)
   - Medium = balanced (recommended)
   - High = only detects obvious movement (might miss things)

4. START AUTO-CLICKING:
   - Press 1 to start the movement clicker
   - It will click on detected movement and wait 15 seconds
   - Press 1 to stop

5. FINE-TUNE SETTINGS:
   Edit the script if needed:
   - gridSize: Smaller = more accurate, larger = faster
   - detectionDelay: How long to wait between snapshots (20ms default)
   - minMovementPoints: How many moving pixels needed (3 default)
   - clickDelay: Time between clicks (15000ms = 15 seconds)

TIPS:
- Start with test mode (key 3) to see what it detects
- Use a smaller search area for better accuracy
- If it detects too much, increase sensitivity or minMovementPoints
- If it misses goblins, decrease sensitivity or gridSize
- Works best when goblins are moving/wandering

TROUBLESHOOTING:
- "No movement detected": Goblins might be standing still, wait for them to move
- "Clicking wrong things": Increase minMovementPoints or sensitivity
- "Too slow": Increase gridSize or decrease detectionDelay
- "Missing goblins": Decrease gridSize or sensitivity
*/

