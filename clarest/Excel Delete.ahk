/* -----------------------------------
Excel Delete
By William Si
(C) 2024

------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

Setup := Gui(, "Delete RX List")
Setup.Opt("+AlwaysOnTop -SysMenu")
Setup.Add("Edit", "r10 vrxList w135", "")
SetupOK := Setup.Add("Button", "Section xm y+25 Default w80", "OK")
SetupOK.OnEvent("Click", Start_Click)  ; Call MyBtn_Click when clicked.
SetupClose := Setup.Add("Button", "w80", "Cancel")
SetupClose.OnEvent("Click", Close_Click)
Setup.OnEvent("Escape", Close_Click)
Setup.BackColor := "A3C3EC"
Setup.Show()

^q::
Close_Click(*) {
ExitApp
}

Start_Click(*) {
global
DeleteRx := Setup.Submit()
rxListArray := StrSplit(Trim(DeleteRx.rxList), ["`r","`n"], " `t")

MyGui := Gui(, "Delete Rx Helper")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")
MyGui.BackColor := "A3C3EC"
MyGui.Add("Text","", "Total Rxs Found: " rxListArray.length)
MyGui.Add("Text", "XP+0 Y+0", "Press Ctrol+Shift+C to enter the Previous rx.")
MyGui.Add("Text", "XP+0 Y+0", "Press Ctrol+Shift+V to enter the next rx.")
LastAllergy := MyGui.Add("Text", " w200", "Previous Allergy:")
NextAllergy := MyGui.Add("Text", "XP+0 Y+0 w200", "Next Rx (#1): " rxListArray[1])
GUIQuit := MyGui.Add("Button", "w80", "Exit")
GUIQuit.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
MyGui.Show("xCenter y0 NoActivate")
}

global i := 1

^+v::
{
global

SendInput rxListArray[i] "!f"
Sleep 500
SendInput "!d"
if WinWaitActive("Confirmation ahk_exe FrameworkLTC.exe", , 5)
SendInput "!y"


i++

if i > rxListArray.length
ExitApp

NextAllergy.Text := "Next Rx (#" i "): " rxListArray[i]
LastAllergy.Text := "Previous RX (#" i-1 "): " rxListArray[i-1]
}

^+c:: {
if i > 1
SendInput rxListArray[i-1]
}