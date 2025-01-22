/* -----------------------------------
Pt Allergies Helper
By William Si
(C) 2024
Helps split and enter patient allergies from the Other Allergies list. 
------------------------------------ */

#SingleInstance Force
TraySetIcon "icon.ico"

;WinWaitActive "ahk_exe FrameworkLTC.exe", "Patient Allergies"
OtherAllergiesList := InputBox("Please copy and paste Other Allergies:", "Allergy Input Helper", "W408 H95")
if OtherAllergiesList.Result = "Cancel" || OtherAllergiesList.Value = ""
ExitApp
OtherAllergiesArray := StrSplit(OtherAllergiesList.Value, ";", "")
for k, v in OtherAllergiesArray {
FoundPos := InStr(v, "(", , -1, )
;Msgbox k "=" v "Found: " FoundPos 
OtherAllergiesArray[k] := SubStr(v, 1, FoundPos-1)
}

global NumberOfAllergies := OtherAllergiesArray.Length

MyGui := Gui(, "Allergy Input Helper")
MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")
MyGui.BackColor := "A3C3EC"
MyGui.Add("Text","", "Total Allergies Found: " OtherAllergiesArray.Length)
MyGui.Add("Text", "XP+0 Y+0", "Press Ctrol+Shift+C to enter the Previous allergy.")
MyGui.Add("Text", "XP+0 Y+0", "Press Ctrol+Shift+V to enter the next allergy.")
LastAllergy := MyGui.Add("Text", " w200", "Previous Allergy:")
NextAllergy := MyGui.Add("Text", "XP+0 Y+0 w200", "Next Allergy: " OtherAllergiesArray[1])
GUIQuit := MyGui.Add("Button", "w80", "Exit")
GUIQuit.OnEvent("Click", Close_Click)  ; Call MyBtn_Click when clicked.
MyGui.Show("xCenter y0 NoActivate")
try {
ControlGetPos &OutX, &OutY, &OutWidth, &OutHeight, "Patient Allergies", "ahk_exe FrameworkLTC.exe"
;MyGui.GetPos(, , &Width)
MyGui.Move(OutX+OutWidth, OutHeight)
}

global i := 1

^+v::
{
global
;static i := 1

SendInput OtherAllergiesArray[i]

i++

if i > NumberOfAllergies
ExitApp

NextAllergy.Text := "Next Allergy: " OtherAllergiesArray[i]
LastAllergy.Text := "Previous Allergy: " OtherAllergiesArray[i-1]
}

^+c:: {
if i > 1
SendInput OtherAllergiesArray[i-1]
}

^q::
Close_Click(*) {
ExitApp
}

