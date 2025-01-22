/* -----------------------------------
CarePack Start Date Reminder
By William Si
(C) 2024
Shows a pop-up box as a reminder to check the start date of rxs.
------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

/* GUI / Pop-up Box */

MyGui := Gui(, "Carepack Start Date")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner -Caption")
MyGui.BackColor := "A3C3EC"
WinSetTransColor("A3C3EC", MyGui)
MyGui.Add("GroupBox", "w153 h35 BackgroundYellow", "**Note Start Date (" FormatTime(,"MM/dd") ")**") ;  

/* Loop to Show and Hide Reminder */

loop {
WinWaitActive "ahk_exe FrameworkLTC.exe", "Rx Entry"
try {
	ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"
	MyGui.Show("x" x+635 " y" y+105 " NoActivate")
	SetTimer HideGUI
} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		MyGui.Show("x" x+240 " y" y-298 " NoActivate")
		SetTimer HideGUI
	}
}
WinWaitClose "ahk_exe FrameworkLTC.exe", "Rx Entry"
SetTimer HideGUI, 0
MyGUI.Hide()
}

HideGUI() {
	if !WinActive("Clinical Warnings Detected",)
		return
	SetTimer , 0
	MyGUI.Hide()
}