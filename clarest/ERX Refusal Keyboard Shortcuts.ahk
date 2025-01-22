/*

ERX Refusals by William Si (Procare LTC CT)

Keyboard Shortcuts to help refuse ERXs

*/

;#WARN VarUnset,Off

/*
Program Setup, Asks User for Settings
*/

Setup := Gui(, "ERX Refusal Setup")
Setup.Opt("+AlwaysOnTop -SysMenu")

Setup.SetFont("underline",)
Setup.Add("Text",, "For PON Duplicates")
Setup.SetFont("Norm",)
Setup.Add("Text",, "NEWRX refusal reason:")
Setup.Add("Edit", "r1 vPONNEW w150", "ERX Cancel Received / Dup PON")
Setup.Add("Text",, "CANRX refusal reason:")
Setup.Add("Edit", "r1 vPONCAN w150", "NOF / DUP PON")
Setup.SetFont("underline",)
Setup.Add("Text",, "Other Refusals")
Setup.SetFont("Norm",)
Setup.Add("Text",, "NEWRX refusal reason:")
Setup.Add("Edit", "r1 vHome w150", "PPD")
Setup.Add("Edit", "r1 vEND w150", "FLU Shots")
Setup.Add("Edit", "r1 vINS w150", "LTC, Order from outside prescriber")
Setup.Add("Text",, "CANRX refusal reason:")
Setup.Add("Edit", "r1 vPgDn w150", "Control RX ERX DC")
MyBtnOk := Setup.Add("Button", "Default w80", "OK")
MyBtnOk.OnEvent("Click", MyBtn_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := Setup.Add("Button", "w80", "Cancel")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
Setup.Show()

Return

/*
Program Start - Pressed OK
*/

MyBtn_Click(*) {
global
ERXRefusalsSetup := Setup.Submit()

/*
Pop-up box to showing user choices
*/

MyGui := Gui(, "ERX Refusals")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")  ; +Owner avoids a taskbar button.
MyGui.SetFont("underline",)
MyGui.Add("Text",, "For PON Duplicates")
MyGui.SetFont("Norm",)
MyGui.Add("Text",, "Press Ctrl+Del to refuse NEWRX with reason: " ERXRefusalsSetup.PONNEW "`nPress Ctrl+PgUp to refuse CANRX with reason: " ERXRefusalsSetup.PONCAN)
MyGui.SetFont("underline",)
MyGui.Add("Text",, "Other Refusals")
MyGui.SetFont("Norm",)
MyGui.Add("Text",, "Press Ctrl+Home to refuse NEWRX with reason: " ERXRefusalsSetup.Home "`nPress Ctrl+End to refuse NEWRX with reason: " ERXRefusalsSetup.END "`nPress Ctrl+Ins to refuse NEWRX with reason: " ERXRefusalsSetup.INS "`nPress Ctrl+PgDn to refuse CANRX with reason: " ERXRefusalsSetup.PgDn)
;MyGui.Add("Text",, "----------------")
MyBtnReload := MyGui.Add("Button", "w80", "Reload (Ctrl+R)")
MyBtnReload.OnEvent("Click", Reload_Click)  ; Call MyBtn_Click when clicked.
MyBtnClose := MyGui.Add("Button", "w80", "Exit (Ctrl+Q)")
MyBtnClose.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
MyGui.Show("x0 y0 NoActivate")
MyGui.GetPos(, , &Width)
MyGui.Move(A_ScreenWidth-Width, A_ScreenHeight/3)

Return

}

#HotIf WinActive("ahk_exe FrameworkLTC.exe")

^Del:: {
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
SendInput ERXRefusalsSetup.PONNEW "!y"
}

^PgUp:: {
if WinActive(, "Order Selection") {
SendInput "!c"
Sleep 500
}
SendInput "!r"
WinWaitActive "Confirmation"
SendInput "!y"
WinWaitActive "Send Cancel Response"
SendInput "{Tab}" ERXRefusalsSetup.PONCAN "!o"
}

^Home:: {
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
SendInput ERXRefusalsSetup.Home "!y"
}

^End:: {
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
SendInput ERXRefusalsSetup.END "!y"
}

^Ins:: {
if WinActive("ahk_exe FrameworkLTC.exe", "Patient")
SendInput "!c"
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe", "Confirmation"
SendInput ERXRefusalsSetup.INS "!y"
}

^PgDn:: {
SendInput "!r"
WinWaitActive "Confirmation"
SendInput "!y"
WinWaitActive "Send Cancel Response"
SendInput "{Tab}" ERXRefusalsSetup.PgDn "!o"
}



#HotIf

^r:: {
Reload
}

^q:: {
ExitApp
}

Close_Click(*) {
ExitApp
}

Reload_Click(*) {
Reload
}
