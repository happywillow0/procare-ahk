TraySetIcon "icon.ico"
#SingleInstance Force

useQuickSig := false

A_TrayMenu.Add()  ; Creates a separator line.
A_TrayMenu.Add("QuickSig", MenuHandler)  ; Creates a new menu item.

MenuHandler(ItemName, ItemPos, MyMenu) {
	global
	if !useQuickSig
	useQuickSig := true
	else
	useQuickSig := false
	MyMenu.ToggleCheck("QuickSig")
	;MsgBox "Use Quick Sig: " useQuickSig 
	;MsgBox "You selected " ItemName " (position " ItemPos ")"
}

Loop {
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - House Stock"
	TrayTip "House Stock Product Detected", "House Stock", 17
	SendInput "!n"
	SetTimer House_Batch
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions"
	SetTimer House_Batch, 0
	if useQuickSig {
		Sleep 500
		SendLevel 1
		SendInput "!m"
		SendLevel 0
	} else {
		Sleep 250
		SendInput "!n"
	}	

	WinWait "ahk_exe FrameworkLTC.exe", "E-Rx Request"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "Rx Entry"
;	Sleep 750
	MouseGetPos &MouseX, &MouseY
	try { 
		ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
		SendInput "{Click " x+500 " " y+418 " }^a"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		SendInput "{Click " x+103 " " y+11 " }^a"
	} }
	SendInput "1{Tab}1+{Tab}{Click " MouseX " " MouseY " 0 }"
	WinWait "Associate"
	SendInput "!n"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "Rx Entry"
	Sleep 1000
	SendInput "!n"
}

House_Batch() {
	if !WinActive("ahk_exe FrameworkLTC.exe", "Select a batch")
		return
	SetTimer , 0
	SendInput "!c{tab}{down}!n"
}

#HotIf WinActive("Error ahk_exe FrameworkLTC.exe")

!n:: {
		A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
		Send "^c"
		ClipWait  ; Wait for the clipboard to contain text.
		MinQty := SubStr(A_Clipboard, 97, -101)
		;MsgBox MinQty
		SetTimer CloseError, 500
		;SendInput "{Enter}"
		;WinClose "Error ahk_exe FrameworkLTC.exe"
		WinWaitClose "Error ahk_exe FrameworkLTC.exe"
		MouseGetPos &MouseX, &MouseY
		try { 
		ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
		SendInput "{Click " x+500 " " y+418 " }" MinQty "{Click " MouseX " " MouseY " 0 }!n"
		} catch {
		try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		SendInput "{Click " x+103 " " y+11 " }^a" MinQty "{Click " MouseX " " MouseY " 0 }!n"
		} }
}

CloseError(*) {
if WinActive("Error ahk_exe FrameworkLTC.exe")
SendInput "{Enter}"
else
SetTimer CloseError, 0
}