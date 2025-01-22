#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

SplashTextOn , 250 , 150, HIPAA Clicker, HIPAA Clicker is active `n  `n `n Ctrl+(Left Click) to Start `n `n Ctrl+Q to Quit`n Ctrl+S to Pause
WinMove, HIPAA Clicker, , 0, 0 


^s::Pause
^LButton::
MouseGetPos, clickX, clickY
Loop {
;MouseGetPos, nowX, nowY
Click, %clickX%, %clickY%
;MouseMove, nowX, nowY
Sleep, 5500
}
return

^q::ExitApp
