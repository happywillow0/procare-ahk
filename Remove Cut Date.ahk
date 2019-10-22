#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


!F3::
SendInput {F3}!e
ControlClick, DateEdit2, , Reorders
SendInput {Delete}!s
Sleep 2000
SendInput {F3}
ControlClick, NumEdit1, , Reorders
Return