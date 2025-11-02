#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
CoordMode, mouse, Screen

addingPoint := False

Gui, a: New, hwndhGui AlwaysOnTop Resize MinSize

Gui, Add, Text,section, Quick Pouch by Nom

Gui, Add, Text,xs w120, Press 1 for normal click
Gui, Add, Text,xs w120, Press 2 for shift click

Gui, Add, CheckBox, vHumanMouse +Disabled, Mouse movement
Gui, Add, CheckBox, vReturnMouse Checked, Move mouse back to start

Gui, Add, Edit, xs w50 
Gui, Add, UpDown,vSize Range0-50000, 50
Gui, Add, Text,yp+3 x+5, Size

Gui, Add, Button, xs w180 h30 gAddPoint, Add point
Gui, Add, Button, xs w180 h30 gClearPoints, Clear points

Gui, Add, Link,xs, <a href="https://www.patreon.com/posts/33697324">Patreon</a> Full version, bonus AHK
Gui, Add, Link,xs, scripts and AHK scripting tutorials

Gui, Show,, Quick Pouch by Nom

start_script()
guiCount:=2
OnMessage(0x112, "WM_SYSCOMMAND")
return

1::
Gui, a: Submit, Nohide
click_points(points1)
return

2::
Gui, a: Submit, Nohide
Send, {Shift down}
click_points(points1)
Send, {Shift up}
return

AddPoint:
Gui, a: Submit, Nohide
width := Size
height := Size
addingPoint := True
KeyWait, LButton, D
hoverColor := "Red"
add_point(points1, "Red")
addingPoint := False
return

ClearPoints:
clear_points(points1)
return

Esc::
ExitApp
return

clear_points(ByRef points) {
	For index, p In points
	{
		num := p.gui
		Gui %num%: Destroy
	}
	points := []
}

add_point(ByRef points, color) {
	global width, height, guiCount
	if (points.maxindex() >= 4) {
		return
	}
	MouseGetPos, currx, curry
	num := overlay_rect(currx, curry, width, height, 3, color)
	x1 := currx - width/2
	x2 := currx + width/2
	y1 := curry - height/2
	y2 := curry + height/2
	points.push({"x1":x1,"y1":y1,"x2":x2,"y2":y2,"gui":num})
}

click_points(ByRef points) {
	global ReturnMouse
	MouseGetPos, currx, curry
	For index, p In points
	{
		click_box(p.x1, p.y1, p.x2, p.y2)
	}
	if (ReturnMouse) {
		ThisMoveMouse(currx, curry)
	}
}

overlay_rect(X:=0, Y:=0, W:=0, H:=0, T:=3, cc:="Red", incr:=True) {
	global guiCount
	X -= W/2
	Y -= H/2
	w2:=W-T
	h2:=H-T
	txt := abs(mod(guiCount,99)+1)
	Gui %txt%: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
	Gui %txt%: Color, %cc%
	;Gui %txt%: Font, s32
	;Gui %txt%: Add, Text, cLime, XXXXX YYYYY
	Gui %txt%: Show, w%W% h%H% x%X% y%Y% NA

	WinSet, Transparent, 150
	WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
	if (incr) {
		guiCount += 1
	}
	return txt
}

start_script() {
	global width,height,points1,points2,points3
	points1 := []
}

click_box(x1, y1, x2, y2) {
	ToolTip
	x += target_random(x1,(x1+x2)/2,x2)
	y += target_random(y1,(y1+y2)/2,y2)
	ThisMoveMouse(x, y)
	sleep, target_random(30,50,60)
	MouseClick, Left
	sleep, target_random(5,10,15)
}

ThisMoveMouse(x, y) {
	global HumanMouse
	if (HumanMouse) {
		;MoveMouse(x, y)
	} else {
		MouseMove, %x%, %y%, 0
	}
}


target_random(min, target, max){
	;redacted
	return target
}



WM_SYSCOMMAND(wp, lp, msg, hwnd)  {
   static SC_CLOSE := 0xF060
   if (wp != SC_CLOSE)
      Return
   
   ExitApp
}

RemoveToolTip:
ToolTip
return

#If addingPoint
LButton::
return