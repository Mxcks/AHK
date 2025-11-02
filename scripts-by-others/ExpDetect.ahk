#SingleInstance force
CoordMode, Mouse, Screen
SetKeyDelay 20
SetMouseDelay 0
SetBatchLines -1
SendLevel 100
#InputLevel, 1
Global oVoice := ComObjCreate("SAPI.SpVoice")


isClicking:=False
StartHotkey := ""


Gui, a: New, hwndhGui AlwaysOnTop Resize MinSize

Gui, Add, Text,section w200, Alt+Left drag to draw rectangle over XP drops
Gui, Add, Text,section xs w200, Combination to press when ending
Gui, Add, Hotkey, w100 h20 gSetHotkey vStartHotkey, %StartHotkey%
Gui, Add, CheckBox, vPressCtrl, +Ctrl
Gui, Add, CheckBox, xs+43 yp vPressAlt, +Alt
Gui, Add, CheckBox, xp+40 yp vPressShift, +Shift
Gui, Add, CheckBox, xs yp+20 vPressEsc, Esc
Gui, Add, CheckBox, xp+43 yp vPressWin, Win
Gui, Add, CheckBox, xp+40 yp vPressSpace, Spacebar

Gui, Add, Button, xs w180 h30 gAddPoint, Add point
Gui, Add, Button, xs w180 h30 gClearPoints, Clear points

Gui, Add, Edit, xs w100
Gui, Add, UpDown, vSecondsBeforeExit Range0-50000, 10
Gui, Add, Text,yp+3 x+5, Time until exit (s)

Gui, Add, DropDownList,xs vexpDropColor w100, White|Lilac|Cyan|Jade|Lime|Yellow|Orange|Pink||
Gui, Add, Text,yp+3 x+5, Exp drop color

Gui, Add, Link,xs, <a href="https://www.patreon.com/nomscripts">Nom Scripts</a>

Gui, Show,, Exp Checker
OnMessage(0x112, "WM_SYSCOMMAND")
SetTimer, CheckExp, 1000
checkExpHits := 0
pointsToClick:=[]
return

SetHotkey:
;if (StartHotkey) {
;	Hotkey, %StartHotkey%, Clicky, ON
;}
oVoice.Speak(StartHotkey . ".", 3)
return

CheckExp:
Gui, a: Submit, Nohide
expColor := 0xC8C8FF
Switch expDropColor
{
Case "White": 	expColor := 0xFFFFFF
Case "Lilac": 	expColor := 0xC8C8FF
Case "Cyan": 	expColor := 0x00FFFF
Case "Jade": 	expColor := 0xC8FFC8
Case "Lime": 	expColor := 0x64FF64
Case "Yellow": 	expColor := 0xFFFF40
Case "Orange": 	expColor := 0xFF981F
Case "Pink": 	expColor := 0xFFC8C8
}
if (!x1) {
	return
}
PixelSearch, xx, yy, % x1, % y1, % x2, % y2, % expColor, 0, Fast RGB
if (ErrorLevel = 0) {
	checkExpHits := 0
	markerText(SecondsBeforeExit-checkExpHits, xx, yy)
} else {
	checkExpHits++
	markerText(SecondsBeforeExit-checkExpHits, x1, y1)
}
if (checkExpHits >= SecondsBeforeExit) {
	oVoice.Speak("Exiting script", 3)
	if (PressCtrl) {
		Send {Ctrl down}
	}
	if (PressAlt) {
		Send {Alt down}
	}
	if (PressShift) {
		Send {Shift down}
	}
	if (PressWin) {
		Send {LWin down}
	}
	if (PressEsc) {
		Send {Esc}
	}
	if (PressSpace) {
		Send {Space}
	}
	if (PressCtrl) {
		Send {Ctrl up}
	}
	if (PressAlt) {
		Send {Alt up}
	}
	if (PressShift) {
		Send {Shift up}
	}
	if (PressWin) {
		Send {LWin up}
	}
	
	For index, p In pointsToClick
	{
		px := p.x
		py := p.y
		Click %px% %py%
		Sleep, 500
	}
	Sleep, 2000
	ExitApp
}
return

Space::
SendInput {F2}
Send {F2}
SendEvent {F2}
return


AddPoint:
Gui, a: Submit, Nohide
KeyWait, LButton, D
MouseGetPos, xxx,yyy
pointsToClick.push({"x":xxx,"y":yyy})
oVoice.Speak("Point added", 3)
return

ClearPoints:
pointsToClick := []
return

midRandom(min,max) {
	mid := (min+max)/2
	Random, rand1, min,mid
	Random, rand2, mid,max
	Random, rand3, rand1,rand2
	return rand3
}


UpdateText(ControlID, NewText)
{
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}


WM_SYSCOMMAND(wp, lp, msg, hwnd)  {
   static SC_CLOSE := 0xF060
   if (wp != SC_CLOSE)
      Return
   
   ExitApp
}

markerText(num, X:=0, Y:=0)
{
	Gui markText: Destroy
	Gui markText: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
	Gui markText: Margin, 1, 1
	Gui markText: Font, s8
	Gui markText: Add, Text,, %num%
	Gui markText: Show,x%X% y%Y% NA, To do
	WinSet, Transparent, 255
}
markerGreen(X:=0, Y:=0, W:=10)
{
X:=X-W/2
Y:=Y-W/2

Gui markerGreen: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
Gui markerGreen: Color, Red ;Color
Gui markerGreen: Show, w100 h100 x%X% y%Y% NA

WinSet, Transparent, 255
WinSet, Region, 0-0 E w%W% h%W%
Return
}

marker(X:=0, Y:=0, W:=0, H:=0)
{
T:=2,
w2:=W-T,
h2:=H-T

Gui marker: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
Gui marker: Color, Red ;Color
Gui marker: Show, w%W% h%H% x%X% y%Y% NA

WinSet, Transparent, 255
WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
Return
}

!LButton::
Tooltip
WinGetPos XN, YN, , , A
MouseGetPos x1, y1
While GetKeyState("LButton","P") {
   MouseGetPos x2, y2
   x:= (x1<x2)?(x1):(x2)
   y:= (y1<y2)?(y1):(y2)
   
   w:= Abs(x2-x1), h:= Abs(y2-y1)
   marker(x, y, w, h)
}
if (x2<x1) {
	tempX := x2
	x2 := x1
	x1 := tempX
}
if (y2<y1) {
	tempY := y2
	y2 := y1
	y1 := tempy
}
Return