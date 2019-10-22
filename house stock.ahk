#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Tip , FrameworkLTC Helper - House Stock (2019/09/26)
Menu, Tray, Add, Reload, Reload,
Menu, Tray, Add, Quit, exit,
Menu, Tray, NoStandard
Menu, Tray, Icon , icon.ico, , 

user := SubStr(A_UserName, 1 , 2) 
Loop {
	WinWait, Warning, , , , This Rx was already reviewed
	if ErrorLevel
		{
		MsgBox, WinWait timed out.
		return
		}
	else
		{
		WinActivate, Warning,
		SendInput %user%!y
		if ErrorLevel
			{
				MsgBox, Send Input Didn't work
				return
			}
		;WinWaitClose
		While WinExist(Warning) {
			WinActivate, Warning,
			Sleep 2000
			}
		}
}


exit:
ExitApp

Reload:
Reload
