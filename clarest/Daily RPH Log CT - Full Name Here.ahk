SetKeyDelay 75
date := FormatTime(, "M/d/yyyy")

/* Get RPH Name */

if InStr(A_UserName, ".")
{
	user_array := StrSplit(A_UserName , ".")
	userF:= SubStr(user_array[1], 1 , 1)
	userL:=	SubStr(user_array[2], 1 , 1)
	initials := userF userL
} else if InStr(A_ScriptName, "-") {
	FoundPos := InStr(A_ScriptName, "-")
	FullName := SubStr(A_ScriptName, FoundPos+2, -4)
	user_array := StrSplit(FullName , " ")
	userF:= SubStr(user_array[1], 1 , 1)
	userL:=	SubStr(user_array[2], 1 , 1)
	initials := userF userL
;	MsgBox "Your Name is " FullName " and your intials are " initials
} else {
MsgBox "Name not Found"
ExitApp
}

Run "https://forms.office.com/r/1aRUuVRWh4"
WinWaitActive "Daily Pharmacist Log Book"
Msgbox "Hold Ctrl and click on `"I attest`" to start." 

^LButton:: {
SendInput "{Click 1}"
Sleep 500
SendInput "{Tab}{Down}{Tab}" user_array[1] " " user_array[2] "{Tab}" initials "{Tab}"
SendEvent date
SendInput "{Tab}{Space}"
ExitApp
}
