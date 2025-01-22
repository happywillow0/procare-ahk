/* -----------------------------------
ERX Quick Sig
By William Si
(C) 2024
Copies the Facility ERX Directions and converts directions to FrameworkLTC sig codes
------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

/*
;External Preferences
quicksig_removerelateddx := false ; Remove Related to ... (ID10)
DefaultSig := true ; Presses Alt+D after quick sig
debug := false
#Include "*i %A_MyDocuments%\ERX Productivity Options.txt"
*/

;GUI for Instructions
MyGui := Gui(, "Quick Sig")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")
MyGui.SetFont("underline",)
MyGui.Add("Text",, "Shortcut Keys:")
MyGui.SetFont("Norm",)
MyGui.Add("Text", "XP+0 Y+2", "Alt+Q: Quick Sig`nAlt+M: Math Sig`nAlt+~: Rx Entry Sig`nAlt+H: Admin Times")
GUIStatus := MyGui.Add("Text", "XP+0 Y+0 w100", "Status: Ready")
;RelatedDx := MyGui.Add("CheckBox", "vDXRelated Check3 Checked", "Related Dx")
RelatedDx := MyGui.Add("CheckBox", "vDXRelated", "Shorten Dx")
RelatedDx.OnEvent("Click", DX_MsgBox)
OverrideRX := MyGui.Add("CheckBox", "vOverride Check3", "Note Dosage")
MyBtnReload := MyGui.Add("Button","w75", "Reload")
MyBtnReload.OnEvent("Click", Reload_Click)
;MyGui.Add("Text",, "Load Time:`n" FormatTime(, "Time"))
MyGui.BackColor := "A3C3EC"
MyGui.Show("x0 y0 NoActivate")
MyGui.GetPos(, , &Width)
MyGui.Move(A_ScreenWidth-Width, 20)

;Only Activate for FW ERX
#HotIf WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions", ,"Rx Entry")

;Alt+Q for basic Quick Sig
!q::{
	MouseGetPos &MouseX, &MouseY
	GUIStatus.Text := "Copy Directions"
	SigString := Interpert_Sig(Get_Directions())
	GUIStatus.Text := "Pasting Sig"
	A_Clipboard := SigString
	SendInput "{Tab}^v"
;	If DefaultSig.Value
	SendInput "!d"
	MouseMove MouseX, MouseY 
	Sig_History("Quick", SigString)
	GUIStatus.Text := "Status: Ready"
}

;Alt+\ for Copy with Default
!\::{
	MouseGetPos &MouseX, &MouseY
	GUIStatus.Text := "Working"
	A_Clipboard := Get_Directions()
	SendInput "{Tab}^v!d"
	MouseMove MouseX, MouseY 
	GUIStatus.Text := "Status: Ready"
}

;Alt+M for advanced Quick Sig with Math
!m:: {
	MouseGetPos &MouseX, &MouseY
	GUIStatus.Text := "Copy Drug"
	DrugString := Get_Drug()
	GUIStatus.Text := "Copy Directions"
	SigString := Get_Directions()
	if OverRideRX.value = 1 or OverRideRX.value = -1 {
	DrugString := InputBox("Please edit DRUG text as needed:", "Override Drug", "w500 h100", DrugString).value
	SigString := InputBox("Please edit SIG text as needed:", "Override Sig", "w500 h100", SigString).value
;	OverRideRX.value := false
	}
	SigString := Interpert_Sig(SigString)
;	Msgbox SigString 
	if InStr(DrugString , "TAB") or InStr(DrugString , "ODT") or InStr(DrugString , "CHEW") or InStr(DrugString , "CAPLET") 
		form := "T"
	else if InStr(DrugString , "CAP")
		form := "C"
	else form := ""
	SigString := StrReplace(SigString, " THEN ", "¢")
	SigString := StrReplace(SigString, " AND ", "¥")
	Position := 0
	Loop parse, SigString, "¢¥"
	{ 
		fullsig .= Trim(mathsig(DrugString, form, A_LoopField))

		; Calculate the position of the delimiter character at the end of this field.
		Position += StrLen(A_LoopField) + 1
		; Retrieve the delimiter character found by the parsing loop.
		DelimiterChar := SubStr(SigString, Position, 1)
		
		if DelimiterChar = "¢"
		fullsig .= " THEN "
		if DelimiterChar = "¥"
		fullsig .= " AND "
	}
	GUIStatus.Text := "Pasting Sig"
	if OverRideRX.value = 1 
	fullsig := "**NOTE DOSAGE** " . fullsig
	OverRideRX.value := false
	A_Clipboard := Trim(fullsig)
	SendInput "{Tab}^v"
	SendInput "!d"
	MouseMove MouseX, MouseY 
	Sig_History(DrugString, Trim(fullsig))
	GUIStatus.Text := "Status: Ready"
}

mathSig(DrugString, form, SigString) {
	If RegExMatch(DrugString, "i)([\d.,]+)-?([\d.]+)*(MCG|MG|GM|UNIT)?\/([\d.]*)(ML)?", &LiqStrength) {
		RegExMatch(SigString , "i)([\d.]+) ?(MG|MCG|ML|GRAM|GM|CC)", &SigDose)
		try {
			DrugML := (LiqStrength[4] = "") ? 1 : LiqStrength[4]
			DrugStrength := StrReplace(LiqStrength[1], ",", "")
			if SigDose[2] = "ML" or SigDose[2] = "CC"  {
				SigStrength := SigDose[1]/DrugML*DrugStrength
				SigStrength := formatStrength(SigStrength)
				if LiqStrength[2]
				SigStrength .= "-" formatStrength(SigDose[1]/DrugML*LiqStrength[2])
				SigStrength .= LiqStrength[3]
				SigString := StrReplace(SigString, "()", "(" SigStrength ")")
			}
			if (SigDose[2] = "MG" or SigDose[2] = "GM" or SigDose[2] = "GRAM" or SigDose[2] = "MCG") {
				SigML := SigDose[1]*DrugML/DrugStrength	
				SigML := formatStrength(SigML) LiqStrength[5]
				SigString := RegExReplace(SigString, "i)\([\d.]+" SigDose[2] "\)", SigML " $0")
			}
		}
	}
	/*
	formPos := RegExMatch(SigString, "i)(\d+?(?:\.\d+?)?)(?:H|Q)?(T|C)(?: \(\))?",)
	dosePos := RegExMatch(SigString , "i)([0-9.]+) *(?:mg|mcg|gram|meq)",) 
	if (formPos and dosePos and formPos < dosePos {
	} 


	*/
	if RegExMatch(SigString, "i)(\d+?(?:\.\d+?)?)(?:H|Q)?(T|C)(?: \(\))?", &SigDose) {
		;RegExMatch(SigString, "i)(\d+?(?:\.\d+?)?)(?:H|Q)?(T|C)(?: \(\))?", &SigDose)
		RegExMatch(DrugString , "i)([\d.]+)[-/]?([\d.]+)* ?(mg|mcg|gram|meq|gm)", &DrugStrength)
		 try {
			if form != ""
			SigString := Tube_Sig(SigString, form)
			else
			SigString := Tube_Sig(SigString, SigDose[2])
			multiplier := InStr(SigString, "1HT") ? 0.5 : (InStr(SigString, "1QT") ? 0.25 : SigDose[1])
    			SigStrength := formatStrength(DrugStrength[1]*multiplier)
			if DrugStrength[2]
			SigStrength .= "-" formatStrength(DrugStrength[2]*multiplier)
			SigStrength .= DrugStrength[3]
			SigString := StrReplace(SigString, "()", "(" SigStrength ")")
		 }
		if form != ""
		SigString := RegExReplace(SigString, "i)([0-9]+)(?:T|C) ", "$1" form " ")
	} else if RegExMatch(DrugString , "i)([0-9.]+) ?(mg|mcg|gram|meq|gm)", &DrugStrength) and RegExMatch(SigString , "i)([0-9.]+) *(?:mg|mcg|gram|meq)", &SigDose) {
		calcDose := formatStrength(SigDose[1]/DrugStrength[1])
		doseqty := StrReplace(calcDose , "0.5", "1H")
		doseqty := StrReplace(doseqty , "0.25", "1Q")
		doseqty := StrReplace(doseqty , "0.75", "3Q")
		if form = ""
			doseqty := "" 
		if form = "T" and calcDose < 0.25
			MsgBox "Warning: The calculated tablet dose of " calcDose " is < 1QT. Please check drug strength", "Drug Strength Error", 16
		if form = "C" and calcDose < 1
			MsgBox "Warning: The calculated capsule dose of " calcDose " is < 1C. Please check drug strength", "Drug Strength Error", 16
		SigString := Tube_Sig(SigString, form)
		SigString := Trim(doseqty form " "  SigString)
		SigString := RegExReplace(SigString, "i)(1(?:T|C)) \(.+?\)", "$1") 
	} 
	return SigString
}

formatStrength(strength) {
    return RTrim(RTrim(Round(strength, 3), "0"), ".")
}

Tube_Sig(SigString, form) {
	if form = "T"
		action := "C"
	else if form = "C"
		action := "O"
	else return SigString
	SigString := StrReplace(SigString, "VGT", action "GT")
	SigString := StrReplace(SigString, "VPT", action "PEG")
	SigString := StrReplace(SigString, "VJT", action "JT")
	return SigString
}

Get_Drug(*) {
	try {
		A_Clipboard := ""
		ControlGetPos &x, &y, &w, &h, "Prescription Directions", "ahk_exe FrameworkLTC.exe"
		SendInput "{Click " x+120 " " y+75 " }^a^c"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "erxdirections.png"
		SendInput "{Click " x+79 " " y+42 " }^a^c"
	} }		
		Sleep 250
		if A_Clipboard = ""
		MsgBox "Copy the drug box to continue`nOr press reload and try again", "Drug Copy Failed"
		ClipWait
		If !WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions", ,"Rx Entry") {
			GUIStatus.Text := "Status: Ready"
			Exit
		}

		return A_Clipboard
	
}

Get_Directions(*) {
	try {
		A_Clipboard := ""
		ControlGetPos &x, &y, &w, &h, "Prescription Directions", "ahk_exe FrameworkLTC.exe"
		SendInput "{Click " x+24 " " y+98 " }{Click " x+120 " " y+120 " }^a^c"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "erxdirections.png"
		SendInput "{Click " x-7 " " y+65 " }{Click " x+79 " " y+86 " }^a^c"
	} }
		Sleep 250
		if A_Clipboard = ""
		MsgBox "Copy the facility directions to continue`nOr press reload and try again", "Directions Copy Failed"
		ClipWait
		If !WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions", ,"Rx Entry") {
			GUIStatus.Text := "Status: Ready"
			Exit
		}
		return A_Clipboard
}

!Up:: {
	MouseGetPos &MouseX, &MouseY
	try {
		ControlGetPos &x, &y, &w, &h, "Prescription Directions", "ahk_exe FrameworkLTC.exe"
		SendInput "{Click " x+24 " " y+98 " }"
	} catch {
	try {
		ImageSearch &x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "erxdirections.png"
		SendInput "{Click " x-7 " " y+65 " }"
	} }
	MouseMove MouseX, MouseY 
}

;Main Sig Code Replacement
Interpert_Sig(SigString) {

;Dose
SigString := StrReplace(SigString, "1/2 mg", "0.5MG")
SigString := StrReplace(SigString, "1,0", "10")

SigString := RegExReplace(SigString, "i)[1-5.]{1,3} ?(?:ml|milliliter|vial|unit)(?: inhale orally|, inhalation)(?: via nebulizer)?", "1UDN")
SigString := RegExReplace(SigString, "i)\(?([\d.]+) *(mg|mcg|GRAMS?|meq|MILLIGRAM)(?: total)?\)?", "($1$2)")
SigString := RegExReplace(SigString, "i)([2-9] (?:tablets?|tabs?|capsules?|caps?))(?:\(s\))?(?:[ =]+\((.+?)\))?", "$1 ($2)")
SigString := RegExReplace(SigString, "i)(\d+) ?(?:mls?|cc|milliliter)(?: \((.+?)\))?", "$1ML ($2)")
;SigString := RegExReplace(SigString, "i)(\d+) ?(?:mls?|cc|milliliter)(?: \((.+?)\))?", "$1ML")
SigString := StrReplace(SigString, "1 PACKET", "1 PACKET ()")
SigString := StrReplace(SigString, "  ", " ")

SigString := StrReplace(SigString, "0.5 tablet", "1HT")
SigString := StrReplace(SigString, "0.5 tab", "1HT")
SigString := StrReplace(SigString, "1 1/2", "1.5")
SigString := StrReplace(SigString, "1/2 tablet", "1HT")
SigString := StrReplace(SigString, "1/2 tab", "1HT")
SigString := StrReplace(SigString, "half of a tablet", "1HT ()")
SigString := StrReplace(SigString, "1HTS", "1HT")
SigString := StrReplace(SigString, "0.25 tablet", "1QT")
SigString := StrReplace(SigString, "1/4ML", "0.25ML")
SigString := StrReplace(SigString, "1/2ML", "0.5ML")
SigString := StrReplace(SigString, "One tablet", "1T")
SigString := StrReplace(SigString, "One tab", "1T")
SigString := StrReplace(SigString, " tablets", "T")
SigString := StrReplace(SigString, " tablet", "T")
SigString := StrReplace(SigString, " tabs", "T")
SigString := StrReplace(SigString, " tab", "T")
SigString := StrReplace(SigString, " capsules", "C")
SigString := StrReplace(SigString, " capsule", "C")
SigString := StrReplace(SigString, " caps", "C")
SigString := StrReplace(SigString, " cap", "C")
SigString := StrReplace(SigString, " drop", "G")
SigString := StrReplace(SigString, " puffs", "P")
SigString := StrReplace(SigString, " puff", "P")
SigString := StrReplace(SigString, " inhalation", "P")
SigString := StrReplace(SigString, " SPRAY", "SP")
SigString := StrReplace(SigString, "UNIT", "UNITS")
SigString := StrReplace(SigString, "UNITSS", "UNITS")

;Route
SigString := StrReplace(SigString, "BY ORAL ROUTE", "PO")
SigString := StrReplace(SigString, "by mouth", "PO")
SigString := StrReplace(SigString, "P,P", "P PO")
SigString := StrReplace(SigString, "orally", "PO")
SigString := StrReplace(SigString, " oral,", " PO")
SigString := StrReplace(SigString, "enterally", "PO")
SigString := StrReplace(SigString, "sublingually", "SL")
SigString := StrReplace(SigString, "under tongue", "SL")
SigString := StrReplace(SigString, "left eye", "OS")
SigString := StrReplace(SigString, "right eye", "OD")
SigString := StrReplace(SigString, "BOTH EYES", "OU")
SigString := StrReplace(SigString, "each eye", "OU")
SigString := StrReplace(SigString, "subcutaneously", "SUBQ")
SigString := StrReplace(SigString, "SUBCUTANEOUS", "SUBQ")
SigString := StrReplace(SigString, "rectally", "P/R")
SigString := StrReplace(SigString, "via G-Tube", "VGT")
SigString := StrReplace(SigString, "G-Tube", "VGT")
SigString := StrReplace(SigString, "gastric tube", "VGT")
SigString := StrReplace(SigString, "VIA PEG-TUBE", "VPT")
SigString := StrReplace(SigString, "via J-Tube", "VJT")
SigString := StrReplace(SigString, "intramuscularly", "IM") 
SigString := StrReplace(SigString, "INTRAMUSCULAR", "IM")
SigString := StrReplace(SigString, "both ears", "AU")
SigString := StrReplace(SigString, "EACH NOSTRIL", "EN")

;Freq
SigString := RegExReplace(SigString, "i)(?:every|q) ?(?:0)?(\d+?)(?: \([a-z]+\))? (?:hours|hrs)", "Q$1H")
SigString := RegExReplace(SigString, "i)oral (\d+)\.0 h", "PO Q$1H")
SigString := RegExReplace(SigString, "i)(?:for|X) (\d+?) days?", "X$1")
SigString := RegExReplace(SigString, "i)one time only (.+) x1", "QD $1 X1")
SigString := RegExReplace(SigString, "i)every (\d+?) day(?:\(s\)|s?)", "Q$1D")
if RegExMatch(SigString, "i)for ([1-4]) weeks?", &WeekVar)
SigString := RegExReplace(SigString, "i)for ([1-4]) weeks?", "X" WeekVar[1]*7)



if RegExMatch(SigString, "i)(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2})", &DateTime) {
xdays := DateDiff(DateTime[3] . DateTime[1] . DateTime[2], FormatTime(, "yyyyMMdd"), "Days")
if xdays = 0 
xdays++
SigString := RegExReplace(SigString, "i)until (\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2})", "X" xdays " (UNTIL $1/$2)", &OutputVarCount, 1)
}

SigString := StrReplace(SigString, "ONCE DAILY AT BEDTIME", "HS")
SigString := StrReplace(SigString, "every day and evening shift", "BID")

SigString := StrReplace(SigString, "EVERY OTHER DAY", "QOD")
SigString := StrReplace(SigString, "every day shift", "QD")
SigString := StrReplace(SigString, "one time a day", "QD")
SigString := StrReplace(SigString, "1 time a day", "QD")
SigString := StrReplace(SigString, "Once A Day", "QD")
SigString := StrReplace(SigString, "once daily", "QD")
SigString := StrReplace(SigString, "every day", "QD")
SigString := StrReplace(SigString, "every morning", "QAM")
SigString := StrReplace(SigString, "in the morning", "QAM")
SigString := StrReplace(SigString, "Once A Morning", "QAM")
SigString := StrReplace(SigString, "IN THE EVENING", "QPM")
SigString := StrReplace(SigString, "EVERY EVENING", "QPM")
SigString := StrReplace(SigString, "Once An Evening", "QPM")
SigString := StrReplace(SigString, "in the afternoon", "QPM")
SigString := StrReplace(SigString, "at bedtime", "HS")
;SigString := StrReplace(SigString, "bedtime", "HS")
SigString := StrReplace(SigString, "PO bedtime", "PO HS")
SigString := StrReplace(SigString, "every night", "HS")
SigString := StrReplace(SigString, "nightly", "HS")
SigString := StrReplace(SigString, "two times a day", "BID")
SigString := StrReplace(SigString, "TWO TIMES DAILY", "BID")
SigString := StrReplace(SigString, "TWICE DAILY", "BID")
SigString := StrReplace(SigString, "2 TIMES A DAY", "BID")
SigString := StrReplace(SigString, "2 times per day", "BID")
SigString := StrReplace(SigString, "2 (TWO) TIMES A DAY", "BID")
SigString := StrReplace(SigString, "2 times daily", "BID")
SigString := StrReplace(SigString, "Twice A Day", "BID")
SigString := StrReplace(SigString, "three times a day", "TID")
SigString := StrReplace(SigString, "3 times daily", "TID")
SigString := StrReplace(SigString, "3 times per day", "TID")
SigString := StrReplace(SigString, "3 times A day", "TID")
SigString := StrReplace(SigString, "3 times QD", "TID")
SigString := StrReplace(SigString, "THREE TIMES DAILY", "TID")
SigString := StrReplace(SigString, "3 (THREE) TIMES A DAY", "TID")
;SigString := StrReplace(SigString, "with meals", "TID w/ meals")
SigString := StrReplace(SigString, "every shift", "QS")
SigString := StrReplace(SigString, "before meals", "AC")
SigString := StrReplace(SigString, "after meals", "PC")
SigString := StrReplace(SigString, "four times a day", "QID")
SigString := StrReplace(SigString, "four times daily", "QID")
SigString := StrReplace(SigString, "4 times daily", "QID")
SigString := StrReplace(SigString, "4 times QD", "QID")
SigString := StrReplace(SigString, "4 (FOUR) TIMES A DAY", "QID")
SigString := StrReplace(SigString, "FIVE TIMES A DAY", "5TD")
SigString := StrReplace(SigString, "as needed", "PRN")
SigString := StrReplace(SigString, "PRN FOR", "PRF")
SigString := StrReplace(SigString, "EVERY HOUR", "Q1H")
SigString := StrReplace(SigString, "EVERY TWO HOURS", "Q2H")
SigString := StrReplace(SigString, "EVERY three HOURS", "Q3H")
SigString := StrReplace(SigString, "EVERY FOUR HOURS", "Q4H")
SigString := StrReplace(SigString, "EVERY six HOURS", "Q6H")
SigString := StrReplace(SigString, "EVERY eight HOURS", "Q8H")
SigString := StrReplace(SigString, "every twelve hours", "Q12H")
SigString := StrReplace(SigString, "Q2D", "QOD")
SigString := StrReplace(SigString, "Q3D", "Q72H")
SigString := StrReplace(SigString, "Q7D", "QW")
SigString := StrReplace(SigString, "ONE TIME A WEEK", "QW")
SigString := StrReplace(SigString, "Q14D", "Q2W")
SigString := StrReplace(SigString, "Q30D", "QM")
SigString := StrReplace(SigString, "QD QOD", "QOD")
SigString := StrReplace(SigString, "HS QOD", "QOHS")
SigString := StrReplace(SigString, "QD QW", "QW")
SigString := StrReplace(SigString, "HS HS", "HS")
SigString := StrReplace(SigString, " HRS", "H")
SigString := StrReplace(SigString, "BID (Q12H)", "BID")
SigString := StrReplace(SigString, "TID (Q8H)", "TID")
SigString := StrReplace(SigString, "QID (Q6H)", "QID")
SigString := StrReplace(SigString, "daily", "QD")
SigString := StrReplace(SigString, "max qd", "MAX DAILY")

;Clean Up Directions
SigString := RegExReplace(SigString, "i)apply to (.*) topically", "APT $1")
SigString := RegExReplace(SigString, "i)(?:lung sounds.*?after(?: tx)?)\.?|(?:post.*?wheeze(?:.*?minutes)?)", "") ; Clean up Neb Orders
SigString := RegExReplace(SigString, "i)INDICATE.*?BELOW.", "") ; Clean up Lidocaine Orders
SigString := RegExReplace(SigString, "i)as part of a \((\d+?(?:MG|MCG))\) dose", "(AS PART OF A $1 DOSE)")

/*
if RelatedDx.value=-1
SigString := RegExReplace(SigString, "i) related.*?\([^ ]*?\)", "") ; Clean up related dx codes
if RelatedDx.value=0
SigString := RegExReplace(SigString, "i) related.*\([^ ]*?\)", "") ; Clean up related dx codes
RelatedDx.value := 1
*/
if RelatedDx.value
SigString := RegExReplace(SigString, "i)related[^(]*(\([^ ]+?\))(?:;[^(]*(\([^ ]*?\)))?(?:;[^(]*(\([^ ]*?\)))?(?:;[^(]*(\([^ ]*?\)))?", "DX:$1$2$3$4") ; Clean up related dx codes
;SigString := RegExReplace(SigString, "i)related\D*(\(.+?\..*?\))(?:;\D*(\(.+?\..*?\)))?(?:;\D*(\(.+?\..*?\)))?(?:;\D*(\(.+?\..*?\)))?", "DX:$1$2$3$4") ; Clean up related dx codes

If InStr(SigString, "Per Sliding Scale, SUBQ,") {
SigString := StrReplace(SigString, "if blood sugar is", "")
SigString := StrReplace(SigString, ", give ", "=")
SigString := StrReplace(SigString, ".", ";")
}

SigString := StrReplace(SigString, "(s)", "")
SigString := StrReplace(SigString, "give ", "", , , )
SigString := StrReplace(SigString, "take ", "")
SigString := StrReplace(SigString, ",", "")
SigString := StrReplace(SigString, "Instill", "INS")
SigString := StrReplace(SigString, "Inject ", "INJ ")
SigString := StrReplace(SigString, "inhale", "INH")
SigString := StrReplace(SigString, "Insert ", "")
SigString := StrReplace(SigString, "Nausea and Vomiting", "N/V")
SigString := StrReplace(SigString, "NAUSEA/VOMITING", "N/V")
;SigString := StrReplace(SigString, "Apply to", "APT")
SigString := StrReplace(SigString, "Apply 1 patch transdermally", "A1P")
SigString := StrReplace(SigString, "OPENC", "OPEN CAPSULE")


SigString := StrReplace(SigString, "Apply", "AP")
SigString := StrReplace(SigString, "PRN PRN", "PRN")
SigString := StrReplace(SigString, "PRN (PRN)", "PRN")
SigString := StrReplace(SigString, "MILLIGRAM", "MG")

SigString := RegExReplace(SigString, "i)(\d)P INH", "INH $1P")
SigString := RegExReplace(SigString, "i)not.*?3.*?24.*?period", "NTE3G")
SigString := RegExReplace(SigString, "i)not.*?4.*?24.*?period", "NTE4G")

;SigString := RegExReplace(SigString, "i)(?:as )?part of \((.+?)\) dose", "(AS PART OF $1 DOSE)")

/* Temp */
SigString := StrReplace(SigString, " 1 SUPPOSITORY", "1SUPP")
SigString := StrReplace(SigString, "RECTAL DAILY", "P/R QD")

;Finish and places the directions back on clipboard
SigString := StrUpper(Trim(SigString))
return SigString
}

;Reload Button
Reload_Click(*) {
Reload
}

#HotIf WinActive("ahk_exe FrameworkLTC.exe", "Rx Entry", ,)
!`:: {
	GUIStatus.Text := "Copy Directions"
	A_Clipboard := ""
	SendInput "^a^c"
	Sleep 250
	if A_Clipboard = ""
		MsgBox "Copy the facility directions to continue`nOr press reload and try again", "Directions Copy Failed"
	ClipWait
	A_Clipboard := Interpert_Sig(A_Clipboard)
	GUIStatus.Text := "Pasting Sig"
	SendInput "^v"
	Sig_History("RX Entry", A_Clipboard)
	GUIStatus.Text := "Status: Ready"
}

#HotIf WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions", ,"Rx Entry") or WinActive("ahk_exe FrameworkLTC.exe", "Rx Entry", ,)

;Alt-H Adds the Admin Times for Carepack
!h::{
	GUIStatus.Text := "Copy Directions"
	A_Clipboard := ""
	SendInput "^a^c"
	Sleep 250
	if A_Clipboard = ""
		MsgBox "Copy the facility directions to continue`nOr press reload and try again", "Directions Copy Failed"
	ClipWait
	A_Clipboard := Carepack_HOA(StrReplace(A_Clipboard, "`r`n"))
	GUIStatus.Text := "Pasting Sig"
	SendInput "^a{Backspace}^v"
	Sig_History("HOA", A_Clipboard)
	GUIStatus.Text := "Status: Ready"
}

Carepack_HOA(SigString) {
	if !InStr(SigString, "@") {
	SigString .= " @ "
	if InStr(SigString, " QD") or InStr(SigString, " QAM") or InStr(SigString, " QOD") or InStr(SigString, " QM") or InStr(SigString, " QW") or InStr(SigString, " BIW") or InStr(SigString, " TIW") or InStr(SigString, " QIW")
	SigString .= "0900 "
	if InStr(SigString, " QPM")
	SigString .= "1700 "
	if InStr(SigString, " HS") or InStr(SigString, " QOHS")
	SigString .= "2100 "
	if InStr(SigString, " BID")
	SigString .= "0900 1700"
	if InStr(SigString, " Q12H")
	SigString .= "0900 2100"
	if InStr(SigString, " TID")
	SigString .= "0900 1300 1700"	
	if InStr(SigString, " Q8H")
	SigString .= "0600 1400 2200"	
	if InStr(SigString, " QID")
	SigString .= "0900 1300 1700 2100"
	if InStr(SigString, " Q6H")
	SigString .= "0000 0600 1200 1800"	
	}

	if InStr(SigString, "QW") || InStr(SigString, "BIW") || InStr(SigString, "TIW") || InStr(SigString, "QIW") || InStr(SigString, "QOD") || InStr(SigString, "QOHS") || InStr(SigString, "QM") || InStr(SigString, "Q48H") || InStr(SigString, "Q72H")
	SigString := RegExReplace(SigString, "i)(\d\d\d)(\d)", "$15" )
	if InStr(SigString, "CHEW")
	SigString := RegExReplace(SigString, "i)(\d\d\d)(\d)", "$14" )
	if InStr(SigString, "OGT") || InStr(SigString, "OPEG") || InStr(SigString, "OJT")
	SigString := RegExReplace(SigString, "i)(\d\d\d)(\d)", "$13" )
	if InStr(SigString, "CGT") || InStr(SigString, "CPEG") || InStr(SigString, "CJT") || InStr(SigString, "DISSOLVE")
	SigString := RegExReplace(SigString, "i)(\d\d\d)(\d)", "$12" )
	if InStr(SigString, "hold")
	SigString := RegExReplace(SigString, "i)(\d\d\d)(\d)", "$11" )
	return SigString
}

Sig_History(drug, sigtext) {
FileAppend FormatTime(, "ddMMMyyyy hh:mm:ss tt") ": (" drug ") " sigtext "`n", A_MyDocuments "\ERX QuickSig History.txt"
}

DX_MsgBox(*) {
if RelatedDx.value
MsgBox "This shortens down related diagnosis codes in the sig.`nPlease double check to make sure nothing extra gets removed.", "Shorten Related Diagnosis", 64
}

;Debug: Press Ctrl+` when Quick Sig window is open 
#HotIf WinExist("Quick Sig ahk_class AutoHotkeyGUI")
^`:: {
TestSigObj := InputBox("Please enter the directions to get your sig codes:", "Manual Quick Sig", "w300 h100")
if TestSigObj.Result = "Cancel"
return
SigString := StrUpper(Interpert_Sig(TestSigObj.Value))
A_Clipboard := SigString
MsgBox "Your Quick Sig is copied on the clipboard.`n" SigString, "Manual Quick Sig"
}
