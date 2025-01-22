#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/**
Auto Discharge Helper
Helps process discharges in ERX looking for prescriptions that match or inactive patients with blank profiles. 
Automates key presses.
*/

;Check if Frameworks is running and brings it to the front. 
If !WinExist("FrameworkLTC for Windows") {
	Run, "C:\Program Files (x86)\SoftWriters\FrameworkLTC\FrameworkLTC.exe" 
	}
Else {
	WinActivate, FrameworkLTC for Windows
	}

Menu, Tray, Tip , FrameworkLTC Helper - Auto Discharge (2019/10/13)
Menu, Tray, Add, Reload, Reload,
Menu, Tray, Add, Quit, exit,
Menu, Tray, NoStandard
Menu, Tray, Icon , icon.ico, , 

;Find Screen Size for Image Search
framex1 = 0
framey1 = 0
framex2 = %A_ScreenWidth%
framey2 = %A_ScreenHeight%

SplashImage , , M1, This will process cancels for inactive patients. `n `n Ctrl+E Open ERX Work Queue `n `n Ctrl+Q to Start `n Alt+Q to Quit `n `n Ctrl+P if order Not On File, FrameworkLTC Auto Discharge, Auto Discharge Ready, 
Return

^e::
SendInput !cww{Enter}
Return

^p::
SendInput !c!r!y{Tab}+n+o+f{Tab}{Enter}	
Return

!q::
ExitApp 
return

^q::
WinActivate, FrameworkLTC for Windows
Search:
ImageSearch, , , framex1, framey1, framex2, framey2, wait.png
if (ErrorLevel = 0) {
WinSetTitle, Auto Discharge, , Auto Discharge Waiting
Sleep 5000
goto, Search
}
else {
	WinSetTitle, Auto Discharge, , Auto Discharge Running
	ImageSearch, , , framex1, framey1, framex2, framey2, cancel.png
	if (ErrorLevel = 0) {
		SendInput !p{Enter}{Enter}{Enter}
		goto, Search
		}
	else {
		ImageSearch, , , framex1, framey1, framex2, framey2, refuse.png
		if (ErrorLevel = 1) {
			ImageSearch, , , framex1, framey1, framex2, framey2, refuse2.png
			if (ErrorLevel = 0) {
				SendInput !p
				sleep, 300
				ImageSearch, , , framex1, framey1, framex2, framey2, inactive.png
				if (ErrorLevel = 0) {
					SendInput !n
					sleep, 300
					ImageSearch, , , framex1, framey1, framex2, framey2, blank.png
					if (ErrorLevel = 0) 
					SendInput !c!r!y{Tab}+n+o+f{Tab}{Enter}
				}
			}
		}	
		else if (ErrorLevel = 0) {
			SendInput !p
			sleep, 300
			ImageSearch, , , framex1, framey1, framex2, framey2, inactive.png
			if (ErrorLevel = 0) {
				SendInput !n
				sleep, 300
				ImageSearch, , , framex1, framey1, framex2, framey2, blank.png
				if (ErrorLevel = 0) 
				SendInput !c!r!y{Tab}+n+o+f{Tab}{Enter}	
			} ; End If for Inactive Patient
		} ; End If for Cancel Non-Match 

	} ; End Else for Cancel Match
	goto, Search
} ; End Else for Waiting for next prescription
return

exit:
ExitApp
Return

Reload:
Reload
Return
