#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
Batch Checker
Double Checks the batch when packing and final reviewing and displays a warning if it is different than what we are working on. 

Change Log: 
10/06 - Fixed Sunday check, now displays 7 instead of 0.
*/



Menu, Tray, Add, Switch Batches, Start,
Menu, Tray, Add, Reload, Reload,
Menu, Tray, Add, Quit, exit,
Menu, Tray, Default, Switch Batches
Menu, Tray, NoStandard
Menu, Tray, Icon , icon.ico, , 
Menu, Tray, Tip , Batch Checker (2019-10-06)

dayname := SubStr(A_DDD, 1 , 2)
StringUpper, dayname, dayname
weekday := A_WDay-1
if (weekday  = 0) 
weekday := 7

Start:
hour := A_Hour
if hour between 3 and 12
id = AM
if hour between 13 and 21
id = PM
if hour not between 2 and 21
id = SW


InputBox, batchnow , Which Batch to Check, Which batch are we working in?`nFor example 2%weekday%AM%dayname%`, 2%weekday%PM%dayname%`, 2%weekday%SW%dayname%?, , , 150, , , , , 2%weekday%%id%%dayname%

NumpadEnter::
Return::
SendInput {Enter}

ControlGetText, fwtext, ThunderRT6TextBox12, , Packaging Information, ,
if (fwtext = "") 
ControlGetText, fwtext, ThunderRT6TextBox31, , Final Review, ,
if (fwtext = "")
Return
FoundPos := RegExMatch(fwtext, "2\d", OutputVar, StartingPosition := 1)
batch := SubStr(fwtext, FoundPos)
Length := StrLen(String)-1
batch := SubStr(batch, 1, Length)
if (batch = "")
Return
if (batch != batchnow) 
{

SetTimer, ChangeButtonNames, 50 
MsgBox, 4113, Wrong Batch,**This RX is supposed to be on %batch%**

IfMsgBox, Cancel
{
Goto Start
}
}
Return

exit:
ExitApp

Reload:
Reload


ChangeButtonNames: 
IfWinNotExist, Wrong Batch
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, Off 
WinActivate 
ControlSetText, Button2, &Change Batch
return