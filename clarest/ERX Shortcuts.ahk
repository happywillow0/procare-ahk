/* -----------------------------------
Text Shortcuts for working with FrameworkLTC
By William Si
(C) 2024
------------------------------------ */

TraySetIcon "icon.ico"
#SingleInstance Force

/*
User Customizations
Copy the example User Shorts File into "OneDrive - Procare LTC\Documents\"
*/

#Include "*i %A_MyDocuments%\User Shortcuts.txt"

/*
Text Replacement / Text Shortcuts / Spell Check
*/

#HotIf WinActive("ahk_exe FrameworkLTC.exe")

; Brand Generics

:*:Apix::eliquis
:*:dapag::Farxiga
:*:empag::Jardiance
:*:linag::Tradjenta
:*:Mirab::myrbetriq
;:*:sitag::januvia
:*:ticag::Brilinta
:*:sacub::entresto
:*:vibeg::gemtesa
:*:rivar::xarelto
::calc,500::oys,500
::poly,510::poly,17
::enox,0.4::enox,40
::lido,2::regenec
::moln::lagev,200,c

; Spell Check

:*:P OBI D::PO BID
:*:P OBID::PO BID
:*:P ODQ::PO QD
:*:P OHS::PO HS
:*:P OQ::PO Q
:*:P OTID::PO TID
:*:P QOD::PO QD
:*:PO Q D::PO QD
:*:PO SH::PO HS
:*:POBID::PO BID
:*:POHS::PO HS
:*:POQ D::PO QD
:*:POQD::PO QD
:*:SPAMS::SPASMS
::1 TPO::1T PO
::RPN::PRN
::UNTIS::UNITS
::UO::OU
:?*:m l(::ML ( 

;Custom Sigs

:*:pax2::UAD 2T (150-100MG) PO BID X5 **DO NOT CRUSH**
:*:pax3::UAD 3T (300-100MG) PO BID X5 **DO NOT CRUSH**
:*:S/W::SOB / WHEEZING
::1CP:: 1C PO QD
::1TP:: 1T PO QD 
::apo::(AS PART OF 
::*daw::**BRAND NAME NECESSARY**
::ERT1GM::INJ 1GM IM QD (MIX W/ 3.2ML OF LIDOCAINE 1%)
::INH1:: INH 1UDN PO 
::INS::INSTILL
::Lage::4C (800mg) PO Q12H x5
::LIDO1GM::MIX 2.1ML W/ ROCEPHIN 1GM QD
::MG0::MG)
::PR::Per rectally
::ROC1GM::INJ 1GM IM QD (MIX W/ 2.1ML OF LIDOCAINE 1% OR STERILE H20)
::ssi::W/ SQ sliding scale:
::vpeg::VIA PEG-TUBE
::zpack::2T (500MG) PO QD X1 THEN 1T PO QD X4
:?:MGD::MG DOSE)

;Carepack Times
GroupAdd "CarePackHOA", "ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Prescription Directions"
GroupAdd "CarePackHOA", "ahk_exe FrameworkLTC.exe", "Rx Entry"
#HotIf WinActive("ahk_group CarePackHOA")

::06::0600
::07::0700
::08::0800
::09::0900
::010::1000
::011::1100
::012::1200
::013::1300
::014::1400
::015::1500
::016::1600
::017::1700
::018::1800
::019::1900
::020::2000
::021::2100
::022::2200

::@6::@ 0600
::@7::@ 0700
::@8::@ 0800
::@9::@ 0900
::@10::@ 1000
::@11::@ 1100
::@12::@ 1200
::@13::@ 1300
::@14::@ 1400
::@15::@ 1500
::@16::@ 1600
::@17::@ 1700
::@18::@ 1800
::@19::@ 1900
::@20::@ 2000
::@21::@ 2100
::@22::@ 2200

::@64::@ 0600 1400
::@66::@ 0600 1600
::@67::@ 0600 1700
::@68::@ 0600 1800
::@69::@ 0600 1900
::@60::@ 0600 2000
::@79::@ 0700 1900
::@83::@ 0800 1300
::@84::@ 0800 1400
::@86::@ 0800 1600
::@87::@ 0800 1700
::@88::@ 0800 1800
::@80::@ 0800 2000
::@90::@ 0900 2000
::@91::@ 0900 2100
::@93::@ 0900 1300
::@94::@ 0900 1400
::@96::@ 0900 1600
::@97::@ 0900 1700
::@98::@ 0900 1800
::@99::@ 0900 1900
::@605::@ 0600 1000 1500
::@086::@ 0000 0800 1600
::@616::@ 0600 1100 1600
::@617::@ 0600 1100 1700
::@628::@ 0600 1200 1800
::@642::@ 0600 1400 2200
::@662::@ 0600 1600 2200
::@729::@ 0700 1200 1900
::@737::@ 0700 1300 1700
::@739::@ 0700 1300 1900
::@826::@ 0800 1200 1600
::@827::@ 0800 1200 1700
::@837::@ 0800 1300 1700
::@830::@ 0800 1300 2000
::@832::@ 0800 1300 2200
::@840::@ 0800 1400 2000
::@841::@ 0800 1400 2100
::@842::@ 0800 1400 2200
::@861::@ 0800 1600 2100
::@927::@ 0900 1200 1700
::@937::@ 0900 1300 1700
::@938::@ 0900 1300 1800
::@931::@ 0900 1300 2100
::@940::@ 0900 1400 2000
::@941::@ 0900 1400 2100
::@942::@ 0900 1400 2200
::@949::@ 0900 1400 1900
::@951::@ 0900 1500 2100
::@961::@ 0900 1600 2100
::@962::@ 0900 1600 2200
::@971::@ 0900 1700 2100
::@8260::@ 0800 1200 1600 2000
::@9271::@ 0900 1200 1700 2100

#HotIf WinActive("ahk_exe FrameworkLTC.exe")

;Other 

:*:QDN::QD!n
:*:QAMN::QAM!n
:*:QPMN::QPM!n
:*:HSN::HS!n

;Query Docutrack and Load Last Document Control-Alt-Q
^!q:: {
	ControlGetPos &x, &y, &w, &h, "Rx Entry", "ahk_exe FrameworkLTC.exe"	
	MouseGetPos &MouseX, &MouseY
	SendInput "{Click " x+615 " " y+335 " }" 
	Sleep 500
	SendInput "!t"
	Sleep 500
	SendInput "{Enter}"
	Sleep 500
	SendInput "{Click}"
	Sleep 500
	SendInput "!q"
	Sleep 500
}

/*
ERX Folder Helper
*/

GroupAdd "ERXSort", "Select Folder"
GroupAdd "ERXSort", "ahk_exe FrameworkLTC.exe", "Select Folder"
GroupAdd "ERXSort", "ahk_exe FrameworkLTC.exe", "Move Item"
#HotIf WinActive("ahk_group ERXSort")
:*:ct1::CT 11
:*:ct2::CT 12
:*:ct3::CT 13
:*:ct4::CT 20
:*:ct5::CT 15
:*:ct8::CT 80
:*:ct9::CT 98
:*:zz::CT 99

/*
IV Print and Refuse
*/

#HotIf WinActive("ahk_exe FrameworkLTC.exe", "Print Request")
;ALT-I
!i::{
SendInput "!p"
Sleep 500
SendInput "!r"
WinWaitActive "ahk_exe FrameworkLTC.exe","Confirmation"
SendInput "IV Printed to DocuTrack!y"
}


/*
DocuTrack HL7 Quick Text
*/

#HotIf WinActive("ahk_exe DocuTrack.exe")
::cdx::Please let the facility know that control rx need diagnosis
::abxx::ABX script needs specific diagnosis
::abxd::Clarify ABX script stop date
::cnd::c diag fyi
:*:HL7:: {
hour := FormatTime(, "H")
if hour >=12 and hour < 17
priority := "e"
else if hour >= 17
priority := "s"
else priority := "m"
SendInput "order cl{TAB 3}C{TAB}F{Tab 2}" priority "{TAB 4}"
}
:*:OOS:: {
hour := FormatTime(, "H")
if hour >=12 and hour < 17
priority := "e"
else if hour >= 17
priority := "s"
else priority := "m"
SendInput "OUT OF{TAB 3}C{TAB}F{Tab 2}" priority "{TAB 4}"
}

^+c:: SendInput "^1c^!s"


/*
Keyboard Shortcuts
*/

#HotIf

^Space::
!Space::
{
if WinExist("Calculator")
{
	if WinActive("Calculator")
		WinActivate "ahk_exe FrameworkLTC.exe"
	else
		WinActivate "Calculator"
}
else
    Run "calc.exe"
Return
}

#HotIf WinActive("ahk_exe FrameworkLTC.exe", "E-Rx Work Queue - Product Selection")

!a:: {
; If (ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "first.png") || ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "activeblue.png") || ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "active.png")) {
If (ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "active.png")) {
	MouseGetPos &MouseX, &MouseY
	SendInput "{Click " ClickX+10 " " ClickY+10 " }{Click " MouseX " " MouseY " 0 }"
	}
If (ImageSearch(&ClickX, &ClickY, 0, 0, A_ScreenWidth, A_ScreenHeight, "preferred.png")) {
	MouseGetPos &MouseX, &MouseY
	SendInput "{Click " ClickX+10 " " ClickY+10 " }{Click " MouseX " " MouseY " 0 }"
	}
}

#HotIf WinActive("Clinical Warnings Detected")
~!m::
~!s::SendInput "+{tab}{PgDn}"
~!n::SendInput "!s!m+{tab}{PgDn}"

