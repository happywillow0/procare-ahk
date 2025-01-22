/* -----------------------------------
Auto ERX
By William Si
(C) 2024
Automates the process of ERX for New Orders, Carepack Orders, Low Priority Orders
------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

/* Close Duplicate Programs */

DetectHiddenWindows True  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
try WinClose "ERX House Stock v2.ahk - AutoHotkey"  ; Update this to reflect the script's name (case-sensitive).
try WinClose "ERX Close Associate.ahk - AutoHotkey"  ; Update this to reflect the script's name (case-sensitive).
DetectHiddenWindows False

/* GUI / Pop-up Box */

Setup := Gui(, "Auto ERX Setup")
;Setup.Opt("+AlwaysOnTop -SysMenu")
Setup.Add("Text",, "Product Selection:")
Setup.Add("ComboBox", "vProductSelection w150", ["Auto","Manual","(Or enter a custom search)"]).Choose(1)
Setup.Add("CheckBox", "vBrandMed", "Brand Name Product?")
HSCheck := Setup.Add("CheckBox", "vHouseStockOnly Checked", "House Stock Products Only?")
QSCheck := Setup.Add("CheckBox", "vQuickSig Check3", "Quick Sig Running?")
CPCheck := Setup.Add("CheckBox", "vCarepack", "Carepack?")
Setup.Add("CheckBox", "vPtOrders", "Check Patient Orders?")
Setup.Add("GroupBox", "w200 h130", "House Stock Settings")
Setup.Add("Text","xP+10 yP+15", "Qty:")
Setup.Add("Edit", "r1 vAutoQty w150", "1")
Setup.Add("CheckBox", "vAutoSave Checked", "Automatically Save?")
Setup.Add("Text",, "Clip Size:")
Setup.Add("Edit", "r1 vClipStart w50", "1")
Setup.Add("Text", "x+m yP+5", "of")
Setup.Add("Edit", "r1 x+m yP-5 vClipSize w50", "999")
SetupOK := Setup.Add("Button", "Section xm y+25 Default w80", "OK")
SetupOK.OnEvent("Click", Start_Click)  ; Call MyBtn_Click when clicked.
SetupClose := Setup.Add("Button", "w80", "Cancel")
SetupClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
Setup.Add("GroupBox", "YS-15 w110 h80", "Quick Settings")
ORClick := Setup.Add("CheckBox", "XP+10 YP+20 vOverride Check3", "Override")
ORClick.OnEvent("Click", OR_MsgBox)
ORNewAdmit := Setup.Add("Radio", "", "New Orders")
ORNewAdmit.OnEvent("Click", Toggle_NewOR)
ORCarepack := Setup.Add("Radio", , "Carepack")
ORCarepack.OnEvent("Click", Toggle_CPOR)
;Setup.OnEvent("Escape", Close_Click)
Setup.OnEvent("Escape", HideGUI)
Setup.BackColor := "A3C3EC"
Setup.Show()

MyGui := Gui(, "Auto ERX")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")
MyGui.BackColor := "A3C3EC"

EndofClip := Gui(, "Auto ERX - END")
EndofClip.Opt("+AlwaysOnTop -SysMenu +Owner")
EndofClip.BackColor := "A3C3EC"
EndofClip.Add("Text",, "End of Clip")
EndofClipReload := EndofClip.Add("Button", "w90", "Reload (Ctrl+R)")
EndofClipReload.OnEvent("Click", Reload_Click)  ; Call MyBtn_Click when clicked.
EndofClipExit := EndofClip.Add("Button", "w90", "Exit (Ctrl+Q)")
EndofClipExit.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.

CarepackGUI := Gui(, "Auto ERX (Carepack)")
CarepackGUI.Opt("+AlwaysOnTop -SysMenu +Owner")
LCaution := CarepackGUI.Add("Picture", "Icon7", "C:\Windows\explorer.exe")
LCaution.Name := "Left"
CarepackGUI.SetFont("Bold Underline s20")
CarepackGUI.Add("Text", "x+m yp", "Check facility administration times!")
RCaution := CarepackGUI.Add("Picture", "Icon7 x+m yp", "C:\Windows\explorer.exe")
RCaution.Name := "Flash1"
CarepackGUI.BackColor := "Yellow"

Return

/* Program Start - Pressed OK */

Start_Click(*) {
global AutoERXSetup := Setup.Submit()

if ORNewAdmit.Value
MyGui.Title := "Auto ERX (New Orders)"
else if ORCarepack.Value
MyGui.Title := "Auto ERX (Carepack)"

If AutoERXSetup.ProductSelection = "Auto"
MyGui.Add("Text",, "Auto Selecting Finish/Active Product")
else if AutoERXSetup.ProductSelection = "Manual"
MyGui.Add("Text",, "Manual Product Selection")
else 
MyGui.Add("Text",, "Auto Searching for: " AutoERXSetup.ProductSelection) 
if AutoERXSetup.Override = -1 {
MyGui.Add("Text", "XP+0 Y+0", "House Stock Disabled")
} else {
IF AutoERXSetup.HouseStockOnly
MyGui.Add("Text", "XP+0 Y+0", "House Stock Products Only")
MyGui.Add("Text", "XP+0 Y+0", "House Stock Qty: " AutoERXSetup.AutoQty " (w/ auto fix)")
if AutoERXSetup.AutoSave
MyGui.Add("Text", "XP+0 Y+0", "Auto Saving House RX")
else
MyGui.Add("Text", "XP+0 Y+0", "Manual Save Mode")
} 
MyGui.Add("GroupBox", "w200 h65", "Instructions")
MyGui.Add("Text", "xP+10 yP+17", "Press Ctrl+I for inactive patient")
GUIReload := MyGui.Add("Text", "XP+0 Y+0", "Press Ctrl+R to reload")
GUIReload.OnEvent("DoubleClick", Reload_Click) 
GUIQuit := MyGui.Add("Text", "XP+0 Y+0", "Press Ctrl+Q to quit")
GUIQuit.OnEvent("DoubleClick", Close_Click) 
global GUIStatus := MyGui.Add("Text", "XP-10 Y+10 w175", "Current Step: Running")
MyGui.Show("xCenter y0 NoActivate")
MyGui.GetPos(, , &Width)
MyGui.Move(A_ScreenWidth-Width, 20)

/* ERX Processing Loop */

Loop {
	if AutoERXSetup.ClipSize != "999" {
	MyGui.Title := "Auto ERX (" A_Index+AutoERXSetup.ClipStart-1 " of " AutoERXSetup.ClipSize " )"
	if (A_Index > AutoERXSetup.ClipSize-AutoERXSetup.ClipStart+1){
		MyGui.Hide()
		EndofClip.Show("xCenter y0 NoActivate")
		exit
		}	
	}
	
	GUIStatus.Text := "Waiting on: ERX Queue"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue", , , " - "
	Sleep 250
	SendInput "!p"

	GUIStatus.Text := "Waiting on: Patient Orders"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Patient Orders"
	If !AutoERXSetup.PtOrders
	SendInput "!n"
	
	GUIStatus.Text := "Waiting on: Product Selection"
	SetTimer Product_Selection

	GUIStatus.Text := "Waiting on: Generic Substitution"
	if AutoERXSetup.BrandMed {
		WinWaitActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Product Selection (Generic Substitution)")
			Sleep 500
			SendInput "{Tab 3}{Up}!n"
	} else SetTimer Generic_Substitution


	GUIStatus.Text := "Waiting on: House Stock Screen"
	global housestock := 0
	IF AutoERXSetup.HouseStockOnly  {
		WinWaitActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - House Stock")
		housestock := 1
		SendInput "!n"
		} 
	else SetTimer House_Stock
	SetTimer House_Batch
	
	GUIStatus.Text := "Waiting on: Directions Screen"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions"
	SetTimer Product_Selection, 0
	SetTimer Generic_Substitution, 0
	SetTimer Select_Brand, 0
	SetTimer House_Stock, 0
	SetTimer House_Batch, 0
	if AutoERXSetup.Override
		global housestock := 1
	if AutoERXSetup.Override = -1
		global housestock := 0
	Sleep 250
	if AutoERXSetup.Carepack and !housestock {
		GUIStatus.Text := "Status: **Press Back Button**"
		SendInput "!b"
		WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Product Selection"
		CarepackGUI.Show("xCenter y0 NoActivate")
		SetTimer ChangeColor,500
		GUIStatus.Text := "Waiting on: Directions Screen"
		WinWaitActive "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions"
		CarepackGUI.Hide()
		SetTimer ChangeColor, 0
		SetTimer ToggleFlash, -1
		Sleep 250
	}
;	MsgBox "Quick " AutoERXSetup.QuickSig " House" housestock
	if AutoERXSetup.QuickSig = 1 and !housestock {
		Sleep 250
		SendLevel 1
		SendInput "!m"
		SendLevel 0
	}
	if AutoERXSetup.QuickSig = -1 and !housestock {
		Sleep 250
		SendLevel 1
		SendInput "!\"
		SendLevel 0
	}
	if housestock {
		Sleep 250
		SendInput "!n"
		GUIStatus.Text := "Waiting on: RX Entry (House Stock)"
	} else
	
	GUIStatus.Text := "Waiting on: RX Entry"
	WinWait "ahk_exe FrameworkLTC.exe", "E-Rx Request"
	WinWaitActive "ahk_exe FrameworkLTC.exe", "Rx Entry"
	if housestock or AutoERXSetup.AutoQty != 1 {
		MouseGetPos &MouseX, &MouseY
		try { 
			ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"
			ToolTip "Control"	
			SendInput "{Click " x+500 " " y+418 " }^a"
		} catch {
		try {
			ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
			ToolTip "Image"
			SendInput "{Click " x+103 " " y+11 " }^a"
		} }
		SendInput AutoERXSetup.AutoQty "{Tab}^a1+{Tab}{Click " MouseX " " MouseY " 0 }"
		ToolTip
	}
	If (AutoERXSetup.AutoSave and housestock) {
		SendInput "!n"
		SetTimer FixQty
		SetTimer FixDCDate
	}

	GUIStatus.Text := "Waiting on: Associate Pop-up"	
	WinWait "Associate"
	SetTimer FixQty, 0
	SetTimer FixDCDate, 0
	SendInput "!n"
	Sleep 1000
} ; End of Loop
} ; End of Button Press Function

/* Loop Functions */

Product_Selection() {
	if !WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Product Selection", , "Generic Substitution")
		return
	SetTimer , 0
	Sleep 500
	SendInput "+{Tab 2}"
	If AutoERXSetup.ProductSelection = "Auto" {
		Active_Product()
		SendInput "!n"
		if WinWaitActive("Product Not Selected", , 0.5) {
			GUIStatus.Text := "No Product Selected"
			SendInput "{Enter}"
			Sleep 500
			MouseGetPos &MouseX, &MouseY
			try {
				ControlGetPos &x, &y, &w, &h, "E-Rx Work Queue - Product Selection", "ahk_exe FrameworkLTC.exe"
				SendInput "{Click " x+(w/2) " " (y+h-72) " }"
			} catch {
			try {
				ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "refinesearch.png"
				SendInput "{Click " x+108 " " y+19 " }"
			} }
			MouseMove MouseX, MouseY
							
		}
	}		
	If (AutoERXSetup.ProductSelection != "Auto") && (AutoERXSetup.ProductSelection != "Manual") {
		SendInput trim(AutoERXSetup.ProductSelection) "{enter}"
		Sleep 250
		SendInput "!n"
	}
}

Active_Product() {
If (ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "active.png")) {
	MouseGetPos &MouseX, &MouseY
	SendInput "{Click " ClickX+10 " " ClickY+10 " }{Click " MouseX " " MouseY " 0 }"
	}
If (ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "preferred.png")) {
	MouseGetPos &MouseX, &MouseY
	SendInput "{Click " ClickX+10 " " ClickY+10 " }{Click " MouseX " " MouseY " 0 }"
	}
}


Generic_Substitution() {
	if !WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Product Selection (Generic Substitution)")
		return
	SetTimer , 0
	Sleep 250
	SendInput "!n"
	SetTimer Select_Brand
}

Select_Brand() {
	if !WinActive("Product Not Selected ahk_exe FrameworkLTC.exe")
		return
	SetTimer , 0
	Sleep 250
	SendInput "{Enter}"
	Sleep 250
	SendInput "{Tab 3}{Up}!n"
}

House_Stock() {
	if !WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - House Stock")
		return 0
	SetTimer , 0
	SendInput "!n"
	global housestock := 1
}

House_Batch() {
	if !WinActive("ahk_exe FrameworkLTC.exe", "Select a batch")
		return
	SetTimer , 0
	SendInput "!c{tab}{down}!n"
}

FixQty() {
	if !WinActive("Error ahk_exe FrameworkLTC.exe")
		return
	SetTimer , 0
	A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
	Sleep 250
	Send "^c"
	GUIStatus.Text := "Press Ctrl+C to copy error message."
	ClipWait  ; Wait for the clipboard to contain text.
	if !InStr(A_Clipboard, "Quantity must be a multiple of")
		return
	GUIStatus.Text := "Attempting to Fix Qty"
	MinQty := SubStr(A_Clipboard, 97, -101)
	SetTimer CloseError, 500
	WinWaitClose "Error ahk_exe FrameworkLTC.exe"
	MouseGetPos &MouseX, &MouseY
	try { 
		ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
		ToolTip "Control"
		SendInput "{Click " x+500 " " y+418 " }" MinQty "{Click " MouseX " " MouseY " 0 }!n"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		ToolTip "Image"
		SendInput "{Click " x+103 " " y+11 " }^a" MinQty "{Click " MouseX " " MouseY " 0 }!n"
	} }
	ToolTip
	GUIStatus.Text := "Waiting on: Associate Pop-up"
}

FixDCDate() {
	if !WinActive("Invalid Dispense Date ahk_exe FrameworkLTC.exe")
		return
	SetTimer , 0
/*
	A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
	Sleep 250
	Send "^c"
	GUIStatus.Text := "Press Ctrl+C to copy error message."
	ClipWait  ; Wait for the clipboard to contain text.
	if !InStr(A_Clipboard, "prescription is discontinued")
		return
*/
	GUIStatus.Text := "Attempting to Fix Date"
	DispDate := FormatTime(, "MM/dd/yyyy")
	SetTimer CloseError
	WinWaitClose "Invalid Dispense Date ahk_exe FrameworkLTC.exe"
	MouseGetPos &MouseX, &MouseY
	try { 
		ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
		ToolTip "Control"
		SendInput "{Click " x+500 " " y+490 " }^a" DispDate "{Click " MouseX " " MouseY " 0 }!n"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		ToolTip "Image"
		SendInput "{Click " x+103 " " y+85 " }^a" DispDate "{Click " MouseX " " MouseY " 0 }!n"
	} }
	ToolTip
	GUIStatus.Text := "Waiting on: Associate Pop-up"
}

CloseError() {
	if WinActive("Error ahk_exe FrameworkLTC.exe") or WinActive("Invalid Dispense Date ahk_exe FrameworkLTC.exe")
		SendInput "{Enter}"
	else
		SetTimer , 0
}

/* GUI Functions */

Toggle_NewOR(*) {
	HSCheck.Value := 0
	QSCheck.Value := ORNewAdmit.Value
	CPCheck.Value := 0
}

Toggle_CPOR(*) {
	HSCheck.Value := 0
	QSCheck.Value := ORCarepack.Value
	CPCheck.Value := ORCarepack.Value
}

ChangeColor() {
if RCaution.Name = "Flash1" {
	if CarepackGUI.BackColor = "FFFF00" {
		CarepackGUI.BackColor := "Default"
		LCaution.Opt("+BackgroundDefault Redraw")
		RCaution.Opt("+BackgroundDefault Redraw")
	} else {
		CarepackGUI.BackColor := "Yellow"
		LCaution.Opt("+BackgroundYellow Redraw")
		RCaution.Opt("+BackgroundYellow Redraw")
	}	
} else {
	CarepackGUI.BackColor := "Yellow"
	if LCaution.Name = "Left" {
		LCaution.Opt("+BackgroundRed Redraw")
		RCaution.Opt("+BackgroundYellow Redraw")
		LCaution.Name := "Right"
	} else {
		LCaution.Opt("+BackgroundYellow Redraw")
		RCaution.Opt("+BackgroundRed Redraw")
		LCaution.Name := "Left"
	}
}
}

ToggleFlash() {
if RCaution.Name = "Flash1"
RCaution.Name := "Flash2"
else 
RCaution.Name := "Flash1"
}

OR_MsgBox(*) {
if ORClick.Value
MsgBox "Treats all orders as house stock / not house stock", "House Stock Override", 64
}

/* Other Hotkeys */

^q::
Close_Click(*) {
ExitApp
}

HideGUI(thisGUI) {
thisGUI.Hide()
}

#HotIf WinActive("ahk_exe FrameworkLTC.exe", , ,"Rx Entry")

^r:: 
Reload_Click(*) {
Reload
}

#HotIf WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue", ,)

^i:: {
if WinActive("ahk_exe FrameworkLTC.exe", "Patient Selection")
SendInput "!c"
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
SendInput "Inactive Patient!y"
Sleep 500
SendInput "!p"
} 

/*
#HotIf
^`:: {
		ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
		ToolTip "Control"
		SendInput "{Click " x+500 " " y+490 " }^a"
		MsgBox "Test"


		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "qtyds.png"
		ToolTip "Image"
		SendInput "{Click " x+103 " " y+85 " }^a"

} 
*/