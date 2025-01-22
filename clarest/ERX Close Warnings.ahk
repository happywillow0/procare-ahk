TraySetIcon "icon.ico"
#SingleInstance Force
SetTitleMatchMode 1

Loop {
	WinWaitActive "Warning"
	try {
		WinGetPos &OutX, &OutY, &OutWidth, &OutHeight, "Warning"
		If OutWidth = 362
			TrayTip "Total Price is less than cost", "Warning", 18
		else If OutWidth = 489 {
			TrayTip "Maximum Supply Warning", "Warning", 18
			;Sleep 5000
			WinWaitClose "Warning"
			continue
		}
		else If OutWidth = 493
			TrayTip "Multiple existing presriptions with serial number", "Warning", 18
		else If OutWidth = 494
			TrayTip "Characters in SIG >180", "Warning", 18
		else If OutWidth = 502
			TrayTip "Prescriber is not part of the NPPES", "Warning", 18
		else {
			TrayTip "Unknown Warning Window Detected", "Warning", 2
			;Sleep 5000
			WinWaitClose "Warning"
			continue
		}

		If WinExist("ahk_exe FrameworkLTC.exe", "E-Rx Request")
			SendInput "!y"
		WinWaitClose "Warning"
	}
}
