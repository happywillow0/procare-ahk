TraySetIcon "icon.ico"
#SingleInstance Force

Loop {
Sleep 2000
WinWaitActive "Associate ahk_exe FrameworkLTC.exe"
SendInput "!n"
WinWaitClose
}
