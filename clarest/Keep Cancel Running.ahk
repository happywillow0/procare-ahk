TraySetIcon "icon.ico"

GroupAdd "RDP", "ahk_exe mstsc.exe"
GroupAdd "RDP", "ahk_exe CredentialUIBroker.exe"

SetTimer ClickRDP, 300000

Loop {
if not WinExist("ahk_group RDP")
Run "C:\Users\WSi\OneDrive - Procare LTC\Desktop\RDS-OneDrive Mini.rdp"
Sleep 5000
WinWaitClose "ahk_group RDP"
}

ClickRDP() {
try{
active_id := WinGetID("A")
if WinExist("ahk_exe mstsc.exe") {
	WinActivate
	WinGetPos &X, &Y, &W, &H, "ahk_exe mstsc.exe"
	DllCall("SetCursorPos", "int", X+(W/2), "int", Y+(H/2))
	SendInput "{Click}"
	WinActivate active_id
	WinGetPos &FWX, &FWY, &FWW, &FWH, active_id
	DllCall("SetCursorPos", "int", FWX+(FWW/2), "int", FWY+(FWH/2))
	}
}
}