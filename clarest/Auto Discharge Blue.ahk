/**

Auto Discharge Helper

Helps process discharges in ERX looking for prescriptions that match or inactive patients with blank profiles. 
Automates key presses.

*/

SetWorkingDir A_InitialWorkingDir
#Warn All, Off
#HotIf WinActive("ahk_exe FrameworkLTC.exe")
showtooltip := 0

MyGui := Gui(, "FrameworkLTC Auto Discharge")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")  ; +Owner avoids a taskbar button.
MyGui.SetFont("underline",)
MyGui.Add("Text",, "This will process cancels for inactive patients.")
MyGui.SetFont("Norm",)
MyGui.Add("GroupBox", "w215 h90", "Instructions:")
MyGui.Add("Text", "xP+10 yP+17", "Ctrl+E Open ERX Work Queue`nCtrl+T to Start`nCtrl+R to Restart`nCtrl+Q to Quit`nCtrl+Delete if order Not On File")
MyGui.SetFont("underline",)
;MyGui.Add("Text",, "Current Activity:")
MyGui.SetFont("Norm",)
MyGui.Add("GroupBox", "XP-10 Y+10 w215 h40", "Current Activity:")
AutoStatus := MyGui.Add("Text", "xP+10 yP+17 w200" , "Auto Discharge Ready")
AutoStatus.OnEvent("Click", DebugToolTip)
MyGui.BackColor := "A3C3EC"
MyGui.Show("xCenter y0 NoActivate")  ; NoActivate avoids deactivating the currently active window.
MyGui.GetPos(, , &Width)
MyGui.Move(A_ScreenWidth-Width, 20)


^r:: {
Reload
Return
}

^e:: {
Send "!cww{Enter}"
Return
}

^t:: {

Loop {

text := 0
title := 0
Sleep 300

AutoStatus.Text := "Checking Window"

try Text := ControlGetText("ThunderRT6FormDC1", "ahk_exe FrameworkLTC.exe")
Title := WinGetTitle("ahk_exe FrameworkLTC.exe")

if showtooltip
ToolTip "Text: " Text "`nTitle: " Title

If (Title = "D/C Order") {
AutoStatus.Text := "Processing D/C"
/*
SetTimer Open_Adj
Sleep 50
SendInput "!y"
WinWaitActive "Update Split Stop Dates ahk_exe FrameworkLTC.exe"
SetTimer Open_Adj , 0
SendInput "!y"
WinWaitActive "Send Cancel Response ahk_exe FrameworkLTC.exe"
SendInput "!o"
*/
Send "!Y"
continue
}

If (Title = "Adjudicated Claim" or Title = "Open Prescription") {
AutoStatus.Text := "Processing D/C: Adj / Open RX"
SendInput "{Enter}"
continue
}

If (Title = "Update Split Stop Dates?") {
AutoStatus.Text := "Processing D/C: Update Split Stop Dates"
Send "!Y"
continue
}

If (Title = "Send Cancel Response") {
AutoStatus.Text := "Processing D/C: Send Cancel Response"
Send "!o"
continue
}

If (text = "E-Rx Work Queue") {
Send "!p"
continue
}

If (text = "E-Rx Work Queue - Patient Selection") {
Send "!n"
continue
}

If (text = "E-Rx Work Queue - Order Selection") {
	WinGetPos &X, &Y, &W, &H, "A"
	If (ImageSearch(&OutputVarX, &OutputVarY, X, Y, X+W, Y+H, "noorders.png")) {
		AutoStatus.Text := "Order NOF"
		Send "!c"
/*
		If (WinWaitActive("Abort Processing", , 0.5)) {
		SendInput "!n"		
		continue
		}
*/
		; Sleep 500
		Send "!r"
		WinWaitActive "Confirmation"
		Send "!Y"
		WinWaitActive "Send Cancel Response"
		Send "{tab}+N+O+F!o"
		Sleep 500
	}
	continue
}

/*
If (Title = "Patient Not Selected") {
	SendInput "{Enter}"
	Sleep 250
	Send "!c"
	Sleep 500
	Send "!r"
	WinWaitActive "Confirmation"
	Send "!Y"
	WinWaitActive "Send Cancel Response"
	SendInput "{tab}New Start: Discharged!o"
	Sleep 500
}


If (Title = "Abort Processing") {
SendInput "!n"
continue
}
*/

} ; End Loop
} ; End Start Function


^Del:: {
AutoStatus.Text := "(Maunal) Order NOF"
Send "!c"
Sleep 500
Send "!r"
WinWaitActive "Confirmation"
Send "!Y"
WinWaitActive "Send Cancel Response"
Send "{tab}+N+O+F!o"
Sleep 500
}

^I:: {
AutoStatus.Text := "(Maunal) IV Order"
Send "!c"
Sleep 500
Send "!r"
WinWaitActive "Confirmation"
Send "!Y"
WinWaitActive "Send Cancel Response"
Send "{tab}ERX IV DC Request!o"
Sleep 500
}

^+C:: {
AutoStatus.Text := "(Maunal) Control RX"
Send "!c"
Sleep 500
Send "!r"
WinWaitActive "Confirmation"
Send "!Y"
WinWaitActive "Send Cancel Response"
Send "{tab}ERX Control DC Request!o"
Sleep 500
}

#HotIf

^q:: ExitApp

DebugToolTip(*) {
global showtooltip := 1
}

Open_Adj() {
	if !WinActive("ahk_group RXInBatch", ,)
		return
	SetTimer , 0
	Sleep DelayMS 
	SendInput "{Enter}"
}
