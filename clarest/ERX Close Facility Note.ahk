TraySetIcon "icon.ico"

Loop {
Sleep 2000
WinWaitActive "Facility Note ahk_exe FrameworkLTC.exe"
; TrayTip "Please check HOA times", "Carepack Home", 17
TrayTip "Facility Note Closed", "Carepack Home", 17
SendInput "{Enter}"
}
