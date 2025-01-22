Setup := Gui(, "Autoclose Clinical Warnings")
Setup.Opt("+AlwaysOnTop -SysMenu")
Setup.Add("CheckBox", "vAutoSave", "Auto Close Clinical Warnings?")
Setup.Add("CheckBox", "vPV2", "PV2?")
Setup.Add("Text",, "Wait (secs):")
Setup.Add("Edit", "r1 vSleepTime w150", "1")
MyBtnOk := Setup.Add("Button", "Default w80", "OK")
MyBtnOk.OnEvent("Click", MyBtn_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := Setup.Add("Button", "w80", "Cancel")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
Setup.Show()
Return

MyBtn_Click(*) {
CloseClinical := Setup.Submit()

Loop {
	Sleep 2000
	WinWaitActive "Clinical Warnings Detected"
	SendInput "+{tab}{PgDn}"
	Sleep CloseClinical.SleepTime*1000
	;MsgBox CloseClinical.AutoSave
	if CloseClinical.AutoSave {
		if CloseClinical.PV2
		SendInput "!m"
		else
		SendInput "!s"
	}
}

}

Close_Click(*) {
ExitApp
}