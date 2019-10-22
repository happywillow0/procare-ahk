FormatTime, month, , MM
month := month+2
FormatTime, day, , dd
day := day-1
FormatTime, year, , yyyy
if (month > 12) {
month := month-12
year := year+1 
} 
FormatTime, yearmonthday, , MM/dd/yyyy
SetKeyDelay 90

;InputBox, rph, Welcome, Please enter your initials: , , , , , , , ,
rph = %A_UserName%

;MsgBox, 49, Script Setup, This script needs to be set up to work fully. Do you want to do this now?,
;IfMsgBox, OK
;Goto, Setup
;Return
Setup:
framex1 = 0
framey1 = 0
framex2 = %A_ScreenWidth%
framey2 = %A_ScreenHeight%
;MsgBox, 0, Screen Setup, Please move the mouse to the top left of the FrameworkLTC screen. Press enter when ready.,
;MouseGetPos, framex1, framey1, , ,
;MsgBox, 0, Screen Setup, Please move the mouse to the bottom right of the FrameworkLTC screen. Press enter when ready.,
;MouseGetPos, framex2, framey2, , ,
;MsgBox, 0, Screen Setup, Please move the mouse to the Department dropdown (CT Pharmacy) of the DocuTrack screen. Press enter when ready.,
;MouseGetPos, docx1, docy1, , ,
ControlGetPos, docx1, docy1, docw, doch, WindowsForms10.Window.8.app.0.2bf8098_r14_ad126, ahk_exe DocuTrack.exe
docx1 := docw/2+docx1
docy1 := doch/2+docy1
;MsgBox, 0, Screen Setup, All Set,
Return

;Suspend Hot Keys
!+s::Suspend

/*
^Numpad0::
SendInput **(NEW RX NEEDED FOR FUTURE FILLS)**
Return
*/

^Numpad1::
InputBox, rxnumber , RX #, RX Number from FrameworkLTC:, , , , 0, 0, , , %rxnumber% 
InputBox,  qtytotal, Quantity Written, Enter total quantity written:, , , , 0, 0, , ,
InputBox, qty , Quantity, Enter quantity dispensed:, , , , 0, 0, , ,%qtytotal%
qtyremain := qtytotal-qty
Goto, copyinfo
Return

^Numpad2::
IfGreater, qtyremain, 0, SendInput **(%qtyremain% LEFT ON RX UNTIL %month%/%day%/%year%)**
ELSE SendInput **(NEW RX NEEDED FOR FUTURE FILLS)**
Return

^Numpad3::
IfGreater, qtyremain, 0, SendInput **(RX EXPIRES %month%/%day%/%year%)**
ELSE SendInput **(NEW RX NEEDED FOR FUTURE FILLS)**
Return

^Numpad6::
Goto, copyinfo
return

^Numpad4::
InputBox, rxnumber , RX #, RX Number from FrameworkLTC:, , , , 0, 0, , , %rxnumber%
InputBox,  qty, Quantity Written, Enter quantity written:, , , , 0, 0, , ,
InputBox,  refills, Number of Refills, Enter any refills granted:, , , , 0, 0, , ,0
qtyremain := qty*(refills)
Clipboard = %yearmonthday%               %rxnumber%              -%qty%                       %rph%                         Refills: %refills% (%qtyremain%)
Return

^Numpad5::
InputBox, rxnumber , RX #, RX Number from FrameworkLTC:, , , , 0, 0, , , %rxnumber% 
InputBox, olddate , Old Date, Date Filled in Fill History:, , , , 0, 0, , , 
InputBox, rphfill , Old RPh, Pharmacist Initials who filled old script:, , , , 0, 0, , , 
InputBox,  qtytotal, Quantity Written, Enter total quantity written:, , , , 0, 0, , ,
InputBox, qty , Quantity, Enter quantity dispensed:, , , , 0, 0, , ,%qtytotal%
qtyremain := qtytotal-qty
Clipboard = %olddate%               %rxnumber%              -%qty%                       %rphfill%                         %qtyremain%
Return

copyinfo:
MsgBox, 36, Dispense Information, A copy of the dispense information will be put into the clipboard. You can put it in the document with Ctrl-V. Do you want the long version with extra spaces?,
IfMsgBox, YES
Clipboard = %yearmonthday%               %rxnumber%              -%qty%                       %rph%                         %qtyremain%
IfMsgBox, NO
Clipboard = %yearmonthday%  %rxnumber%  -%qty%  %rph%  %qtyremain%
Return

!m::
WinActivate, ahk_exe DocuTrack.exe
SendInput ^qmm^!s
Return

!+c::
WinActivate, ahk_exe DocuTrack.exe
SendInput ^qmm^rc^1c^!s
Return

/*
!r::
WinActivate, ahk_exe DocuTrack.exe
MouseGetPos, mousex, mousey, , ,
MouseClick , LEFT, docx1, docy1
SendInput Mm{Tab}r{Tab}C
SendInput ^!s
MouseMove, mousex, mousey
Return
!n::
WinActivate, ahk_exe DocuTrack.exe
SendInput ^!n
Return
*/


!+r::
WinActivate, ahk_exe DocuTrack.exe
SendInput ^rN^1O^!s
Return


!,::
ControlClick, ThunderRT6CommandButton26, ahk_exe FrameworkLTC.exe, , L, 1, , ,
ControlClick, Mark as "Reviewed", Clinical Warnings Detected!!!, , L, 1, , ,
;MouseGetPos, mousex, mousey, , ,
;ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, CHECK.png
;IF OutputVarX
;MouseClick , LEFT, OutputVarX+5, OutputVarY+5
;ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, REVIEW.png
;IF OutputVarX
;MouseClick , LEFT, OutputVarX+5, OutputVarY+5
;MouseMove, mousex, mousey
return


^+w::
MouseGetPos, xpos, ypos
Msgbox, The cursor is at X%xpos% Y%ypos%.
return


^+e::
ImageSearch, OutputVarX, OutputVarY, 1690, -124, 2570, 1457, *50 savenext.png
Msgbox, The  check is found at at X%OutputVarX% Y%OutputVarY%. Error Level %ErrorLevel%
MouseMove, OutputVarX+10, OutputVarY+40
return

^!Numpad2::
IfGreater, qtyremain, 0, MsgBox The value in the variable named qtyremain is %qtyremain%.
ELSE MsgBox The value in the variable named qtyremain is %qtyremain%. ***
Return


!a::
MouseGetPos, mousex, mousey, , ,
ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, active.png
IF OutputVarX {
MouseClick , LEFT, OutputVarX+5, OutputVarY+5
SendInput !n
}
;ImageSearch, OutputVarX, OutputVarY, framex1, framey1, framex2, framey2, REVIEW.png
;IF OutputVarX
;MouseClick , LEFT, OutputVarX+5, OutputVarY+5;MouseMove, mousex, mousey
return
