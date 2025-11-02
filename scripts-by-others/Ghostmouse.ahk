#Persistent
#SingleInstance, Force
CoordMode, Mouse, Screen


recording:=False

Gui, New, hwndhGui AlwaysOnTop Resize MinSize
Gui, Add, Text, x10 w120, Start/stop recording Alt+1`nCancel playback Esc
Gui, Add, Button, xs section w180 gRunRecording, Playback Alt+2
Gui, Add, Button, xs section w180 gDeleteRecording, Delete recording Alt+3
Gui, Add, Edit, xs +Disabled section w50
Gui, Add, UpDown, +Disabled Range0-100, 20
Gui, Add, Text,yp+3 x+5, Random delay `%
Gui, Add, Edit, +Disabled xs section w50
Gui, Add, UpDown, +Disabled Range0-10000, 5
Gui, Add, Text,yp+3 x+5, Random clicks (pixels)
Gui, Add, Text, xs w120 vStatus, Idle

Gui, Add, Link,xs, <a href="https://www.patreon.com/posts/33697324">Full version</a>
Gui, Add, Text, xs , Randomize clicks/delays
Gui, Add, Text, xs , Tracks click drags`, key hold up/down

Gui, Show,, GhostMouse AHK
return

~Esc::
UpdateText("Status", "Idle")
return

!1::
ToggleRecord:
if (recording) {
	recording:=False
	UpdateText("Status", "Idle")
	Goto SaveRecording
} else {
	recording:=True
	UpdateText("Status", "Recording")
	SetTimer, MouseMovementListener, 10
	logg := ""
	timeSinceLast := A_TickCount
	lastX := 0
	lastY := 0
	lineCount := 0
}
return

MouseMovementListener:
MouseGetPos, x,y
if (lastX == x && lastY == y) {
	return
}
LogMove(x, y)
lastX := x
lastY := y
return

LogPress(textt) {
	global logg
	k := SubStr(textt,2)
	LogSleep(true)
	logg .= "Send {" . k . "}`n"
}

LogClick(textt, X, Y) {
	k := SubStr(textt,2,1)
	global logg
	LogSleep(true)
	logg .= "MouseClick, " k ", " X ", " Y "`n"
}

LogMove(X, Y) {
	global logg
	LogSleep()
	logg .= "MouseMove, " X ", " Y "`n"
}

LogSleep(rand:=false) {
	global logg, timeSinceLast, lineCount, recording
	if (!recording) {
		return
	}
	delay := max(A_TickCount - timeSinceLast,10)
	if (rand) {
		logg .= "Sleep, rand`(" . delay . "," . Round(delay*1.2) . "`)`n"
	} else {
		logg .= "Sleep, " . (A_TickCount - timeSinceLast) . "`n"
	}
	timeSinceLast := A_TickCount
	lineCount++
}

~LButton::
~RButton::
~MButton::
MouseGetPos, xx,yy
LogClick(A_ThisHotkey,xx,yy)
return

~F1::
~F2::
~F3::
~F4::
~F5::
~F6::
~F7::
~F8::
~F9::
~F10::
~F11::
~F12::
~q::
~w::
~e::
~r::
~t::
~y::
~u::
~i::
~o::
~p::
~a::
~s::
~d::
~f::
~g::
~h::
~j::
~k::
~l::
~z::
~x::
~c::
~v::
~b::
~n::
~m::
~CapsLock::
~Space::
~Tab::
~Enter::
~Return::
~BS::
~ScrollLock::
~Del::
~Ins::
~Home::
~End::
~PgUp::
~PgDn::
~Up::
~Down::
~Left::
~Right::
LogPress(A_ThisHotkey)
return

UpdateText(ControlID, NewText)
{
	; Unlike using a pure GuiControl, this function causes the text of the
	; controls to be updated only when the text has changed, preventing periodic
	; flickering (especially on older systems).
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}

!2::
RunRecording:
UpdateText("Status", "Playing back")
ahk:=A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe" : A_AhkPath
IfNotExist, %ahk%
{
  MsgBox, 4096, Error, Can't Find %ahk% !
  Exit
}
Run, %ahk% /r "%filename%"
return

!3::
DeleteRecording:
FileDelete, %filename%
return

SaveRecording:
filename := lineCount . "Recording.ahk"
Array := []
Array.Push("CoordMode, Mouse, Screen")
Array.Push("SetKeyDelay -1")
Array.Push("SetMouseDelay -1")
Array.Push("SetBatchLines -1")
Array.Push("loop")
Array.Push("{")
for index, element in Array
{
    FileAppend, % element, %filename%
	FileAppend, `n, %filename%
}

FileAppend, % logg, %filename%

Array := []
Array.Push("}")
Array.Push("return")
Array.Push("rand`(min,max`){")
Array.Push("Random, rrr,min,max")
Array.Push("return rrr")
Array.Push("}")
Array.Push("~Esc::")
Array.Push("ExitApp")
for index, element in Array
{
    FileAppend, % element, %filename%
	FileAppend, `n, %filename%
}
return



GuiClose:		;close Gui to Exit
GuiEscape:		;press Esc to Exit
ExitApp