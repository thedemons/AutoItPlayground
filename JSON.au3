#include-once
#include "_header.au3"

;~ $js = Json('{"mapid":0,"background": "data\map0background.jpg","h":1000,"w":2000, "objs":{ "obj1":{ "sprite" : "objsprite", "x" : 10, "y" : 10, "w" : 100, "h" : 100 } }}')
;~ For $obj In $js.objs.Properties_
;~ 	MsgBox(0,"",$obj.h)
;~ Next

Func Json($str)

	Local $len = StringLen($str), $pLastKey = 2, $Split, $sRemoveKey
	Local $Data = IDispatch(), $key, $value

	For $i = 1 To $len

		$char = StringMid($str, $i, 1)
		If $char = ":" Then

			$key = StringSplit( StringMid($str, $pLastKey, $i), ":", 1 )
			If IsArray($key) = False Then ContinueLoop


			$key = __StrParse($key[1], True)
			If $key = False Then ContinueLoop

			$sRemoveKey = StringTrimLeft($str, $i)

			$value = __JsonGetBlock($sRemoveKey, False)

			; not a json block
			If $value = False Then

				$Split = StringSplit($sRemoveKey, ",", 1)

				If $Split[0] = 1 Then $Split[1] = StringTrimRight($Split[1], 1)

				$Data.__add($key, __StrParse($Split[1]))

				$i += StringLen($Split[1])
			Else

				$Data.__add($key, Json($value))

				$i += StringLen($value)
			EndIf

			$pLastKey = $i + 2
		EndIf
	Next

	Return $Data

EndFunc

Func __JsonGetBlock($str, $isFind = False)

	Local $len = StringLen($str)
	Local $pStart = 1, $Open = 0, $pEnd = 0

	If $isFind Then
		For $i = 1 to $len

			If StringMid($str, $i, 1) = "{" Then
				$pStart = $i
				ExitLoop
			EndIf
		Next
	EndIf

	If StringMid($str, $pStart, 1) <> "{" Then Return False

	For $i = $pStart + 1 To $len

		$char = StringMid($str, $i, 1)

		If $char = "{" Then $Open += 1
		If $char = "}" Then $Open -= 1

		If $Open < 0 Then
			$pEnd = $i
			ExitLoop
		EndIf
	Next

	If $pEnd > 0 Then Return StringMid($str, $pStart, $pEnd)

	Return False

EndFunc

Func __StrParse($Str, $check = False)

	While StringLeft($str, 1) = " "
		$str = StringTrimLeft($str, 1)
	WEnd

	While StringRight($str, 1) = " "
		$str = StringTrimRight($str, 1)
	WEnd

	If StringLeft($str, 1) <> '"' Or StringRight($str, 1) <> '"' Then
		If StringRegExp( StringLeft($str, 1), "[0-9]" ) Then Return $check ? False : $str
	EndIf

	Return StringTrimRight(StringTrimLeft($str, 1), 1)
EndFunc

Func __isJSON($str)

	If __JsonGetBlock($str, False) Then Return True
	Return False

EndFunc