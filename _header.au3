#include-once
#include <WinAPIGdi.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <AutoItObject.au3>
#include <Misc.au3>

_AutoItObject_Startup()
_GDIPlus_Startup()

Global $__fEngineSetting = "data\setting.db"


;~ #include "TCP.au3"
#include "Engine.au3"
#include "Env.au3"
#include "Player.au3"
#include "Camera.au3"
#include "Object.au3"
#include "JSON.au3"

Global $Gui, $Engine

Func __msgEngineFailed()
	MsgBox(0, "error", "Failed to initalize game egine")
	Exit
EndFunc

Func print($str, $errCode = 0, $return = False)

	Local $prefix

	Switch $errCode
		Case 0
			$prefix = ">"
		Case 1
			$prefix = "+>"
		Case 2
			$prefix = "!"
	EndSwitch

	ConsoleWrite($prefix & " " & $str & @CRLF)

	Return $return
EndFunc