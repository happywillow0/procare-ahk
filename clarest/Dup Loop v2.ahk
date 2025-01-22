/* -----------------------------------
Dup PON Refuser 
By William Si
(C) 2024
Helps process 99 Refusals and PON Duplicates
------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

Setup := Gui(, "Easy Refusal Setup")
Setup.Opt("+AlwaysOnTop -SysMenu")
Setup.SetFont("underline",)
Setup.Add("Text",, "Refusal Type:")
Setup.SetFont("Norm",)
RefuseList := Setup.Add("ListBox", "vRefuseType r4", ["NEWRX","CANRX","Controls","Census"])
RefuseList.OnEvent("Change", List_Change)
Setup.Add("Text",, "Clip Size:")
Setup.Add("Edit", "r1 vClipStart w30", "1")
Setup.Add("Text", "x+m yP+5", "of")
Setup.Add("Edit", "r1 x+m yP-5 vClipSize w70", "0")
;Setup.Add("Edit", "r1 vClipSize w150", "0")
Setup.SetFont("underline",)
Setup.Add("Text", "xm", "Refusal Reason")
Setup.SetFont("Norm",)
RefuseHeader := Setup.Add("Text",, "Choose a Refusal Type Above")
RefuseText := Setup.Add("Edit", "r1 vRefusalReason w150", "")
MyBtnOk := Setup.Add("Button", "Default w80", "OK")
MyBtnOk.OnEvent("Click", MyBtn_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := Setup.Add("Button", "w80", "Cancel")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
Setup.BackColor := "A3C3EC"
Setup.Show()
Return

List_Change(*) {
if RefuseList.value = 1 {
RefuseHeader.Text := "NEWRX refusal reason:"
RefuseText.Text := "ERX Cancel Received / Dup PON"
} else 
if RefuseList.value = 2 {
RefuseHeader.Text := "CANRX refusal reason:"
RefuseText.Text := "NOF / DUP PON"
} else 
if RefuseList.value = 3 {
RefuseHeader.Text := "Control Cancel refusal reason:"
RefuseText.Text := "Control ERX DC"
} else 
if RefuseList.value = 4 {
RefuseHeader.Text := "Census Cancel refusal reason:"
RefuseText.Text := "Census processed by billing"
} 
}

MyBtn_Click(*) {
ERXRefusalsSetup := Setup.Submit()

MyGui := Gui(, "Easy Refusals")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")  ; +Owner avoids a taskbar button.
if ERXRefusalsSetup.RefuseType = "NEWRX" {
	MyGui.Add("Text",, "Refusing New RX")
} else if ERXRefusalsSetup.RefuseType = "CANRX" {
	MyGui.Add("Text",, "Refusing Cancel RXs")
} else if ERXRefusalsSetup.RefuseType = "Controls" {
	MyGui.Add("Text",, "Refusing Control RXs")
} else if ERXRefusalsSetup.RefuseType = "Census" {
	MyGui.Add("Text",, "Refusing Census Messages")
}
MyGui.Add("Text",, "Refusal Reason: " ERXRefusalsSetup.RefusalReason)
;MyGui.Add("Text",, "----------------")
MyBtnReload := MyGui.Add("Button", "w80", "Reload (Ctrl+R)")
MyBtnReload.OnEvent("Click", Reload_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := MyGui.Add("Button", "w80", "Exit (Ctrl+Q)")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
MyGui.BackColor := "A3C3EC"
MyGui.Show("xCenter y0 NoActivate")

EndofClip := Gui(, "Loop End")
EndofClip.BackColor := "A3C3EC"
EndofClip.Opt("+AlwaysOnTop -SysMenu +Owner")  ; +Owner avoids a taskbar button.
EndofClip.Add("Text",, "End of Clip")
MyBtnReload := EndofClip.Add("Button", "w80", "Reload (Ctrl+R)")
MyBtnReload.OnEvent("Click", Reload_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := EndofClip.Add("Button", "w80", "Exit (Ctrl+Q)")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.


Loop {
	MyGui.Title := "DUP PON (" A_Index+ERXRefusalsSetup.ClipStart-1 " of " ERXRefusalsSetup.ClipSize " )"
	if (A_Index > ERXRefusalsSetup.ClipSize-ERXRefusalsSetup.ClipStart+1){
		MyGui.Hide()
		EndofClip.Show("xCenter y0 NoActivate")
		exit
		}	
	if ERXRefusalsSetup.RefuseType = "CANRX"
	Sleep 500
	Sleep 1000
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue", , , "E-Rx Request"
	if (ERXRefusalsSetup.RefuseType = "NEWRX" || ERXRefusalsSetup.RefuseType = "Census" )  {
		SendInput "!r"
		WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
		SendInput ERXRefusalsSetup.RefusalReason "!y"
	} else if (ERXRefusalsSetup.RefuseType = "CANRX" || ERXRefusalsSetup.RefuseType = "Controls") {
		WinGetPos &X, &Y, &W, &H, "A"
		if (ImageSearch(&OutputVarX, &OutputVarY, X, Y, X+W, Y+H, "cancelMatch.png") && ERXRefusalsSetup.RefuseType = "CANRX") {
		SendInput "!p"
		WinWaitActive "D/C Order ahk_exe FrameworkLTC.exe"
		WinWaitActive "Send Cancel Response ahk_exe FrameworkLTC.exe"
		} else {
		SendInput "!r"
		WinWaitActive "Confirmation"
		SendInput "!y"
		WinWaitActive "Send Cancel Response"
		SendInput "{Tab}" ERXRefusalsSetup.RefusalReason "!o" 
		}
	}
}
}

Close_Click(*) {
ExitApp
}

Reload_Click(*) {
Reload
}

^r:: {
Reload
}

^q:: {
ExitApp
}




