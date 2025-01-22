TraySetIcon "icon.ico"

#SingleInstance Force

Loop {
if not WinExist("ahk_exe FrameworkLTC.exe")
Run "C:\Program Files (x86)\SoftWriters\FrameworkLTC\FrameworkLTC.exe"
WinWaitClose "ahk_exe FrameworkLTC.exe"
}
