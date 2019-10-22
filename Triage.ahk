#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;New
!n::SendInput ^rn^!s
;Control
!c::SendInput ^rc^!s
;Refill
!r::SendInput ^rr^!s
;PV1
!p::SendInput ^rn^1p^!s
;Trash
!t::SendInput ^rt^!s
;Billing
!b::SendInput ^qb^!s