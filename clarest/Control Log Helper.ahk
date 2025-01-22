/* Pop-up Windows for CII and CIII-CV */

#SingleInstance Force
TraySetIcon "icon.ico"
CoordMode "Mouse", "Screen"

C2Gui := Gui(, "CII Helper")
C2Gui.Opt("+AlwaysOnTop -SysMenu")
C2Gui.Add("Text", "", "Date Written:")
CIIDate := C2Gui.Add("DateTime", "vDate w120")
C2Gui.Add("Text", "", "RX Number:")
CIIRx := C2Gui.Add("Edit", "r1 vRxNumber")
C2Gui.Add("Text", "", "Total Qty Written:")
CIIQty := C2Gui.Add("Edit", "r1 vQtyWritten", "")
CIIQty.OnEvent("Change", CIIQtyCopy)  
C2Gui.Add("Text", "", "Qty Dispensed:")
CIIDispense := C2Gui.Add("Edit", "r1 vQtyDisp", "")
C2GuiOK := C2Gui.Add("Button", "Default w80", "OK")
C2GuiOK.OnEvent("Click", CII_Start)  
;C2GuiClose := C2Gui.Add("Button", "w80", "Cancel")
;C2GuiClose.OnEvent("Click", HideGUI)
C2Gui.OnEvent("Escape", HideGUI)
C2Gui.BackColor := "A3C3EC"

C35Gui := Gui(, "C3-5 Helper")
C35Gui.Opt("+AlwaysOnTop -SysMenu")
C35Gui.Add("DateTime", "vDate w120")
C35Gui.Add("Text", "", "RX Number:")
C35Rx := C35Gui.Add("Edit", "r1 vRxNumber")
C35Gui.Add("Text", "", "Total Qty Written:")
C35Qty := C35Gui.Add("Edit", "r1 vQtyWritten", "")
C35Gui.Add("Text", "", "# of Refills:")
C35Refills := C35Gui.Add("Edit", "r1 vRefills", "")
C35GuiOK := C35Gui.Add("Button", "Default w80", "OK")
C35GuiOK.OnEvent("Click", C35_Start) 
;C35GuiClose := C35Gui.Add("Button", "w80", "Cancel")
;C35GuiClose.OnEvent("Click", C35Gui.Hide())
C35Gui.OnEvent("Escape", HideGUI)
C35Gui.BackColor := "A3C3EC"

OldFillGui := Gui(, "Past Control Helper")
OldFillGui.Opt("+AlwaysOnTop -SysMenu")
OldFillGui.Add("Text", "", "RX Number:")
OldFillGui.Add("Edit", "r1 vRxNumber")
OldFillGui.Add("Text", "", "Date Dispensed:")
OldFillGui.Add("DateTime", "vDate w120")
OldFillGui.Add("Text", "", "Qty Available:")
OldFillGui.Add("Edit", "r1 vQtyWritten", "")
OldFillGui.Add("Text", "", "Qty Dispensed:")
OldFillGui.Add("Edit", "r1 vQtyDisp", "")
OldFillGui.Add("Text", "", "Pharmacist Initials:")
OldFillGui.Add("Edit", "r1 vRPH", "")
OldFillOK := OldFillGui.Add("Button", "Default w80", "OK")
OldFillOK.OnEvent("Click", Old_Start) 
OldFillGUI.OnEvent("Escape", HideGUI)
OldFillGui.BackColor := "A3C3EC"

BackOrderGUI := Gui(, "Back Order Helper")
BackOrderGUI.Opt("+AlwaysOnTop -SysMenu")
BackOrderGUI.Add("Text", "", "RX Number:")
BackOrderGUI.Add("Edit", "r1 vRxNumber")
BackOrderGUI.Add("Text", "", "Backordered Drug Name:")
BackOrderGUI.Add("Edit", "r1 vdrugname")
BackOrderGUI.Add("Text", "", "Quantity Ordered:")
BackOrderGUI.Add("Edit", "r1 vorderqty")
BackOrderGUI.Add("Text", "", "Quantity Sent:")
BackOrderGUI.Add("Edit", "r1 vsentqty")
BackOrderOK := BackOrderGUI.Add("Button", "Default w80", "OK")
BackOrderOK.OnEvent("Click", BO_Start) 
BackOrderGUI.OnEvent("Escape", HideGUI)
BackOrderGUI.BackColor := "A3C3EC"

ClarifyGUI := Gui(, "Order Clarification")
ClarifyGUI.Opt("+AlwaysOnTop -SysMenu")
ClarifyGUI.Add("Text", "", "Faci-Unit:")
OCUnit :=  ClarifyGUI.Add("Edit", "r1 vfaciUnit")
ClarifyGUI.Add("Text", "", "Drug Name:")
OCDrug :=  ClarifyGUI.Add("Edit", "r1 vdrugName")
ClarifyOK := ClarifyGUI.Add("Button", "Default w80", "OK")
ClarifyOK.OnEvent("Click", OC_Start) 
ClarifyGUI.OnEvent("Escape", HideGUI)
ClarifyGUI.BackColor := "A3C3EC"

^Numpad0:: {
	SendInput "**(NEW RX NEEDED FOR FUTURE FILLS)**"
}

^Numpad1:: 
showCII(*) {
	MouseGetPos &MouseX, &MouseY
	C2Gui.Show("X" MouseX " Y" MouseY )
	CIIRx.Focus()
}

CIIQtyCopy(*) {
CIIDispense.Value := CIIQty.Value
}

^Numpad2:: {
	try {
		qtyremain := CIIQty.Value-CIIDispense.Value
		if (qtyremain > 0)
			SendInput "**(" qtyremain " LEFT ON RX UNTIL " FormatTime(DateAdd(CIIDate.Value, 60, "Days"), "ShortDate") ")**" ;A_Now
		else
			SendInput "**(NEW RX NEEDED FOR FUTURE FILLS)**"
	} catch {
		showCII()
	}
}

^Numpad3:: {
	try {
		qtyremain := CIIQty.Value-CIIDispense.Value
		if (qtyremain > 0)
			SendInput "**(RX EXPIRES ON " FormatTime(DateAdd(CIIDate.Value, 60, "Days"), "ShortDate") ")**" ;A_Now
		else
			SendInput "**(NEW RX NEEDED FOR FUTURE FILLS)**"
	} catch {
		showCII()
	}
}

^Numpad4:: 
showC35(*) {
	MouseGetPos &MouseX, &MouseY
	C35Gui.Show("X" MouseX " Y" MouseY )
	C35Rx.Focus()
}

^Numpad5:: 
showOLD(*) {
	MouseGetPos &MouseX, &MouseY
	OldFillGui.Show("X" MouseX " Y" MouseY )	
}

^Numpad8::
showOC(*){
	OCUnit.Value := ""
	OCDrug.Value := ""
	MouseGetPos &MouseX, &MouseY
	ClarifyGUI.Show("X" MouseX " Y" MouseY )

	A_Clipboard := "" 
	ToolTip "Copy Unit Info From Docutrack"
	ClipWait 5
	OCUnit.Value := A_Clipboard
	A_Clipboard := "" 
	ToolTip "Copy Drug Info From Docutrack"
	ClipWait 5
	OCDrug.Value := A_Clipboard
	ToolTip
}

^Numpad9:: 
showBO(*) {
	MouseGetPos &MouseX, &MouseY
	BackOrderGUI.Show("X" MouseX " Y" MouseY )

	
}

CII_Start(*) {
CIIData := C2Gui.Submit()
try {
QtyRemain := CIIData.QtyWritten-CIIData.QtyDisp
;Copy_Info(FormatTime(CIIData.Date, "ShortDate"), CIIData.RxNumber, CIIData.QtyDisp, A_UserName, QtyRemain)
Copy_Info(FormatTime(, "ShortDate"), CIIData.RxNumber, CIIData.QtyDisp, A_UserName, QtyRemain)
} catch {
showCII() 
}
}

C35_Start(*) {
	C35Data := C35Gui.Submit()
	try {
		QtyRemain := "Refills: " C35Data.Refills " (" C35Data.QtyWritten*C35Data.Refills ")" 
		Copy_Info(FormatTime(C35Data.Date, "ShortDate"), C35Data.RxNumber, C35Data.QtyWritten, A_UserName, QtyRemain)
	} catch {
		showC35() 
	}
}

Old_Start(*) {
	OldData := OldFillGui.Submit()
	try {
		QtyRemain := OldData.QtyWritten-OldData.QtyDisp
		Copy_Info(FormatTime(OldData.Date, "ShortDate"), OldData.RxNumber, OldData.QtyDisp, OldData.RPH, QtyRemain)
	} catch {
		showOLD()
	}
}

BO_Start(*) {
	BOData := BackOrderGUI.Submit()
	qtyremain := BOData.orderqty-BOData.sentqty
		A_Clipboard := "IBO " BOData.rxnumber " " BOData.drugname " ORDERED " BOData.orderqty " SENT " BOData.sentqty " OWE " qtyremain
	try {
		
		MsgBox "Initial Back Order Sig is copied on the clipboard"
	} catch {
		showBO()
	}
}

OC_Start(*) {
	OCData := ClarifyGUI.Submit()
	try {
	WinActivate "ahk_exe DocuTrack.exe"
	SendInput "^4{Tab 2}^a"
	unitArray := StrSplit(OCData.faciUnit , ":", " ")
	;MsgBox unitArray[3]
	unit := SubStr(unitArray[3], 1, -2)
	;MsgBox unit
	SendInput unit "{Tab}^a" OCData.drugName
	} catch {
		showOC()
	}
}


Copy_Info(date, rxnumber, qty, rph, qtyremain) {
Result := MsgBox("A copy of the dispense information will be put into the clipboard. You can put it in the document with Ctrl-V. Do you want the long version with extra spaces?", "Dispense Information", 36)
if Result = "Yes"
A_Clipboard := date "               " rxnumber "              -" qty "                       " rph "                         " qtyremain
else
A_Clipboard := date " " rxnumber " -" qty " " rph " " qtyremain
}

HideGUI(thisGUI) {
thisGUI.Hide()
}