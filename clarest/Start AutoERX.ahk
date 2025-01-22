DetectHiddenWindows True  ; Allows a script's hidden main window to be detected.
SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
PostMessage 0x0111, 65306,,, "ERX House Stock v2.ahk - AutoHotkey"  ; Pause.
PostMessage 0x0111, 65306,,, "ERX Close Associate.ahk - AutoHotkey"  ; Pause.

Run '"AutoHotkey64.exe" "Auto ERX (GUI).ahk"'