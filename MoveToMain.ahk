;;--- Head --- Informations --- AHK ---

;;	VLC reset position VLC x64 only. Reset position of VLC and/or start if not.
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode

;;--- Softwares options ---

	SetWorkingDir, %A_ScriptDir%
	SetTitleMatchMode, 2
	#NoEnv
	#SingleInstance Force
	#Persistent

	SetEnv, title, MoveToMain
	SetEnv, mode, Move Windows To Main Monitor
	SetEnv, version, Version 2017-11-11-1031
	SetEnv, Author, LostByteSoft
	SetEnv, logoicon, ico_recycle.ico

	;; User variable, change if you want anything else.
	SetEnv, shortkey, F2
	SetEnv, displacement, 3

	SysGet, Mon1, Monitor, 1

	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_HotKeys.ico, ico_HotKeys.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_recycle.ico, ico_recycle.ico, 0
	FileInstall, ico_debug.ico, ico_debug.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0
	FileInstall, ico_pause.ico, ico_pause.ico, 0

;;--- Tray options

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, ico_options.ico
	Menu, tray, add, Exit %title%, Close					; Close exit program
	Menu, Tray, Icon, Exit %title%, ico_shut.ico
	Menu, tray, add, Refresh (ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (ini mod), ico_reboot.ico
	Menu, tray, add, Set Debug (Toggle), debug
	Menu, Tray, Icon, Set Debug (Toggle), ico_debug.ico
	Menu, tray, add, Pause (Toggle), pause
	Menu, Tray, Icon, Pause (Toggle), ico_pause.ico
	Menu, tray, add,
	Menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, ico_options.ico
	Menu, Tray, add, Select displacement = 0 = xy, changedisp0
	Menu, Tray, add, Select displacement = 1 = xywh, changedisp1
	Menu, Tray, add, Select displacement = 2 = xyh, changedisp2
	Menu, Tray, add, Select displacement = 3 = Full, changedisp3
	Menu, tray, add,
	Menu, Tray, add, Hotkey = %shortkey%, trayclick
	Menu, Tray, Icon, Hotkey = %shortkey%, ico_HotKeys.ico
	Menu, tray, add,
	Menu, Tray, Tip, %mode% - %shortkey%

;;--- Software start here ---

Start:
	KeyWait, %shortkey% , D

move:
	WinGetTitle, activeWindow, A
	sleep, 100
	WinActivate, %activeWindow%
	SetEnv, Var1, %Mon1Right%
	Var1 /= 12
	SetEnv, Var2, %Var1%
	Var2 *= 10
	SetEnv, Var3, %Mon1Bottom%
	Var3 /= 8
	SetEnv, Var4, %Var3%
	Var4 *= 6

	;;MsgBox, %activeWindow% to %var1% %var3% %var2% %var4%

	IfEqual, displacement, 0, goto, displacement0
	IfEqual, displacement, 1, goto, displacement1
	IfEqual, displacement, 2, goto, displacement2
	IfEqual, displacement, 3, goto, displacement3
	goto, displacement3

	displacement0:
	;; xy
	WinMove, %activeWindow%, , %var1%, %var3%,
	Goto, start

	displacement1:
	;; xywh
	WinMove, %activeWindow%, , %var1%, %var3%, %var2%, %var4%
	Goto, start

	displacement2:
	;; xyh
	SetEnv, bottom, %mon1Bottom%
	bottom -= 38			; 38 traybar
	WinMove, %activeWindow%, , %var1%, 0,, %bottom%
	Goto, start

	displacement3:
	;; xyh
	SetEnv, bottom, %mon1Bottom%
	bottom -= 38			; 38 traybar
	WinMove, %activeWindow%, , 0, 0, %Mon1Right%, %Bottom%
	Goto, start

;;--- Debug Pause ---

debug:
	IniRead, debug, MoveActiveToSecondMonitor.ini, options, debug
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	SetEnv, debug, 0
	IniWrite, 0, MoveActiveToSecondMonitor.ini, options, debug
	goto, doReload

	debug1:
	SetEnv, debug, 1
	IniWrite, 1, MoveActiveToSecondMonitor.ini, options, debug
	goto, doReload

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
	Menu, Tray, Icon, ico_pause.ico
	SetEnv, pause, 1
	goto, sleep

	unpaused:	
	Menu, Tray, Icon, ico_time_w.ico
	SetEnv, pause, 0
	Goto, start

	sleep:
	Menu, Tray, Icon, ico_pause.ico
	sleep, 24000
	goto, sleep

;;--- Quit (escape , esc) ---

Close:
	ExitApp

doReload:
	Reload
	sleep, 500
	goto, Close

;;--- Tray Bar (must be at end of file) ---

trayclick:
	TrayTip, %title%, %mode% Click on a windows., 2, 1
	sleep, 250
	KeyWait, LButton, D
	sleep, 250
	goto, move


changedisp0:
	SetEnv, displacement, 0
	Return

changedisp1:
	SetEnv, displacement, 1
	Return

changedisp2:
	SetEnv, displacement, 2
	Return

changedisp3:
	SetEnv, displacement, 3
	Return

secret:
	MsgBox, 48, %title%,title=%title% mode=%mode% version=%version% author=%author% shortkey=%shortkey% displacement=%displacement% logoicon=%logoicon% A_ScriptDir=%A_ScriptDir%`n`nMain screen resolution Left: %Mon1Left% -- Top: %Mon1Top% -- Right: %Mon1Right% -- Bottom %Mon1Bottom%
	return

about:
	TrayTip, %title%, %mode% %author%, 2, 1
	Return

version:
	TrayTip, %title%, %version%, 2, 2
	Return

author:
	SetEnv, Var1, %Mon1Right%
	Var1 /= 12
	SetEnv, Var2, %Var1%
	Var2 *= 10
	SetEnv, Var3, %Mon1Bottom%
	Var3 /= 8
	SetEnv, Var4, %Var3%
	Var4 *= 6
	MsgBox, 64, %title%, %title% %mode% %version% %author% This software is usefull when windows goes off the sreen resolution and dissapear. New displacement (if 1) move to %var1% %var3% %var2% %var4% (if 0) move to %var1% %var3% (Automatic calculating according to your screen resolution.).`n`n`tGo to https://github.com/LostByteSoft
	Return

GuiLogo:
	Gui, Add, Picture, x25 y25 w400 h400 , %logoicon%
	Gui, Show, w450 h450, %title% Logo
	Gui, Color, 000000
	return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;      The warranty is included in your anus. Look carefully you
;             might miss all theses small characters.
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;              LostByteSoft no copyright or copyleft.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---