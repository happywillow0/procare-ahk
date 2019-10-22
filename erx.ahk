#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Tip , FrameworkLTC Helper - ERX (2019/10/21)

;Setup
framex1 = 0
framey1 = 0
framex2 = %A_ScreenWidth%
framey2 = %A_ScreenHeight%

;Shortcuts

^Numpad0::
SendInput !c!r!y{Tab}+n+o+f{Tab}{Enter}	
Return

!a::
ControlFocus, ThunderRT6CommandButton6, , E-Rx Work Queue - Product Selection
SendInput +{Tab}+{Tab}+{Tab}{Down}!n
/*
MouseGetPos, mousex, mousey, , ,
ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, active.png
IF OutputVarX {
MouseClick , LEFT, OutputVarX+5, OutputVarY+5
SendInput !n
}
;ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, REVIEW.png
;IF OutputVarX
;MouseClick , LEFT, OutputVarX+5, OutputVarY+5
MouseMove, mousex, mousey
*/
return

!Up::
ControlFocus, ThunderRT6CommandButton6, , E-Rx Work Queue - Product Selection
SendInput +{Tab}+{Tab}+{Tab}{Up}{Up}{Up}{Up}{Up}{Up}
Return

!Down::
ControlFocus, ThunderRT6CommandButton6, , E-Rx Work Queue - Product Selection
SendInput +{Tab}+{Tab}+{Tab}{Down}
Return


#Include U:\AutoCorrect.ahk