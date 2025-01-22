TraySetIcon "icon.ico"
#SingleInstance Force
DelayMS := 50

GroupAdd "RXInBatch", "Adjudicated Claim"
GroupAdd "RXInBatch", "Open Prescription"

Loop {
	WinWaitActive "D/C Order ahk_exe FrameworkLTC.exe"
	TrayTip "ERX D/C Order Detected", "ERX Auto D/C", 17
	SetTimer Open_Adj
	Sleep DelayMS 
	SendInput "!y"
	WinWaitActive "Update Split Stop Dates ahk_exe FrameworkLTC.exe"
	SetTimer Open_Adj , 0
	Sleep DelayMS 
	SendInput "!y"
	WinWaitActive "Send Cancel Response ahk_exe FrameworkLTC.exe"
	Sleep DelayMS 
	SendInput "!o"
	TrayTip
}

Open_Adj() {
	if !WinActive("ahk_group RXInBatch", ,)
		return
	SetTimer , 0
	Sleep DelayMS 
	SendInput "{Enter}"
}
