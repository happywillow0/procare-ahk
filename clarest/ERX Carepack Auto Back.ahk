Loop {
WinWait "ahk_exe FrameworkLTC.exe", "Patient Orders"
WinWaitClose "ahk_exe FrameworkLTC.exe", "Patient Orders"
if WinWait("ahk_exe FrameworkLTC.exe", "Product Selection", 0.5)
; or WinWait("ahk_exe FrameworkLTC.exe", "House Stock", 0.5)
continue
WinWait "ahk_exe FrameworkLTC.exe", "Prescription Directions"
Sleep 250
SendInput "!b"
}