#include-once
#include <_header.au3>
;~ $guiw = 1280
;~ $guih = 960
;~ $gui = GUICreate("", $guiw, $guih)
;~ GUISetState()

;~     $hDC = _WinAPI_GetDC($GUI)
;~     Local $hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $guiw, $guih)
;~     $buffer = _WinAPI_CreateCompatibleDC($hDC)
;~     Local $DC_obj = _WinAPI_SelectObject($buffer, $hHBitmap)
;~     Global $context = _GDIPlus_GraphicsCreateFromHDC($buffer)
;~     _GDIPlus_GraphicsSetSmoothingMode($context, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
;~     _GDIPlus_GraphicsSetPixelOffsetMode($context, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)


;~ Local $playerPoints[4]

;~ For $i = 0 To UBound($playerPoints) - 1
;~ 	$playerPoints[$i] = IDispatch()
;~ 	$playerPoints[$i].__add("x", Random(50, 350))
;~ 	$playerPoints[$i].__add("y", Random(50, 350))
;~ Next

;~ $playerPoints[0].x = 50
;~ $playerPoints[0].y = 50
;~ $playerPoints[1].x = 100
;~ $playerPoints[1].y = 50
;~ $playerPoints[2].x = 100
;~ $playerPoints[2].y = 100
;~ $playerPoints[3].x = 50
;~ $playerPoints[3].y = 100

;~ Local $objpoints[11]

;~ For $i = 0 To UBound($objpoints) - 1
;~ 	$objpoints[$i] = IDispatch()
;~ 	$objpoints[$i].__add("x", Random(200, 900))
;~ 	$objpoints[$i].__add("y", Random(200, 900))
;~ Next
;~ HotKeySet("a","test")
;~ $player = IDispatch()
;~ $player.__add("points", $playerPoints)
;~ $player.__add("centerX", 0)
;~ $player.__add("centerY", 0)
;~ $player.__add("accelX", 0)
;~ $player.__add("accelY", 0)
;~ $player.__method("update", "PlayerUpdate")
;~ $player.__method("move", "PlayerMove")
;~ $node = IDispatch()
;~ $node.__add("points", $objpoints)
;~ $obj = IDispatch()
;~ $obj.__add("x", 0)
;~ $obj.__add("y", 0)
;~ $node.__add("parent", $obj)

;~ $red = _GDIPlus_PenCreate(0xFFFF0000, 2)
;~ $gray = _GDIPlus_PenCreate(0x22000000, 2)
;~ $green = _GDIPlus_PenCreate(0xFF77DD77, 3)
;~ $blue = _GDIPlus_PenCreate(0xFF7777DD, 3)
;~ $brushred = _GDIPlus_BrushCreateSolid(0xFFFF0000)

;~ $zxc = IDispatch()
;~ $zxc.__add("context", $context)
;~ $zxc.__add("gui", $gui)
;~ $graphic = _Graphic($zxc)

;~ Local $polygon = $graphic.polygon($objpoints)
;~ $polygon.color = _GDIPlus_PenCreate(0xFF000000)

;~ Local $polygon2 = $graphic.polygon($playerPoints)
;~ $polygon2.color = _GDIPlus_PenCreate(0xFFFF0000)

;~ Func test()
;~ 	Local $str
;~ 	For $i = 0 To UBound($objpoints) - 1
;~ 		$str &= '"x' & $i + 1 & '":' & $objpoints[$i].x & ',"y' & $i + 1 & '":' & $objpoints[$i].y & ","
;~ 	Next
;~ 	ClipPut($str)
;~ EndFunc
;~ Global $time

;~ While 1

;~ 	If GUIGetMsg() = - 3 then Exit

;~ 	$cur = GUIGetCursorInfo()
;~ 	If IsArray($cur) = False Then ContinueLoop

;~ 	$player.update
;~ 	$centerobj = _Polygon_Centeroid($objpoints)
;~ 	$centerplayer = _Polygon_Centeroid($playerPoints)
;~ 	$player.centerX = $centerplayer[0]
;~ 	$player.centerY = $centerplayer[1]
;~ 	$player.accelX += ($cur[0] - $centerplayer[0]) / 50
;~ 	$player.accelY += ($cur[1] - $centerplayer[1]) / 50

;~ 	_WinAPI_BitBlt($buffer, 0, 0, $guiw, $guih, $buffer, 0, 0, 0xFFFFFFFF)
;~ 	$graphic.update

;~ 	_GDIPlus_GraphicsFillEllipse($context, $centerobj[0] - 8, $centerobj[1] - 8, 16, 16, $brushred)
;~ 	_GDIPlus_GraphicsFillEllipse($context, $centerplayer[0] - 8, $centerplayer[1] - 8, 16, 16, $brushred)

;~ 	_GDIPlus_GraphicsDrawLine($context, $centerplayer[0], $centerplayer[1], $centerplayer[0] + $player.accelX, $centerplayer[1] + $player.accelY, $blue)


;~ 	$its = _IsIntersect($player, $node)


;~ 	If IsArray($its) Then
;~ 		For $i = 0 To UBound($its) - 1
;~ 			$rX1 = $objpoints[$its[$i][3]].x
;~ 			$rY1 = $objpoints[$its[$i][3]].y
;~ 			$idx = $its[$i][3] >= UBound($objpoints) - 1 ? 0 : $its[$i][3] + 1
;~ 			$rX2 = $objpoints[$idx].x
;~ 			$rY2 = $objpoints[$idx].y
;~ 			_GDIPlus_GraphicsDrawLine($context, $rX1, $rY1, $rX2, $rY2, $green)
;~ 			_GDIPlus_GraphicsDrawEllipse($context, $its[$i][0] - 5, $its[$i][1] - 5, 10, 10, $red)
;~ 		Next
;~ 	EndIf

;~ 	_GDIPlus_GraphicsDrawString($context, "FPS: " & Round(1000 / TimerDiff($time)), 5, 5)
;~ 	$time = TimerInit()
;~ 	_WinAPI_BitBlt($hDC, 0, 0, $guiw, $guih, $buffer, 0, 0, $SRCCOPY) ;blit drawn bitmap to GUI
;~ WEnd

;~ Func PlayerUpdate($self)

;~ 	$self.accelX -= $self.accelX / 10
;~ 	$self.accelY -= $self.accelY / 10
;~ 	Local $points = $self.points
;~ 	For $i = 0 To UBound($points) - 1
;~ 		$points[$i].x += $self.accelX
;~ 		$points[$i].y += $self.accelY
;~ 	Next
;~ 	$polygon2.points = $points
;~ EndFunc
;~ Func PlayerMove($self, $x, $y)

;~ 	Local $points = $self.points
;~ 	For $i = 0 To UBound($points) - 1
;~ 		$points[$i].x += $x
;~ 		$points[$i].y += $y
;~ 	Next
;~ 	$polygon2.points = $points
;~ EndFunc
Func _IsIntersect($player, $node)
	Local $index, $DX, $DY, $dot, $DX2, $DX2, $cits
	Local $pointIts1, $pointsIts2, $distIts, $distClose, $distRe, $cits2 = 0, $isIts = False
	Local $cplayer = UBound($player.points), $cpoint = UBound($node.points)
	Local $playerPoints[$cplayer][2]
	Local $count = 0, $intersect
	Local $aPoints[2]

	If $cplayer < 3 Or $cpoint < 3 Then Return False


	For $p = 0 To $cplayer - 1

		$cits = 0
		For $i = 0 To $cpoint - 1


			$index = $i = $cpoint - 1? 0 : $i + 1

			$point1 = $node.points[$i]
			$point2 = $node.points[$index]
			$intersect = _IsIntersectLine(-100000, -100000, $player.points[$p].x, $player.points[$p].y, $node.parent.x + $point1.x, $node.parent.y + $point1.y, $node.parent.x + $point2.x, $node.parent.y + $point2.y)

			If IsArray($intersect) Then $cits += 1
		Next

		If $cits > 0 And Mod($cits, 2) = 1 Then
			$isIts = True
			ExitLoop
		EndIf
	Next

	If $isIts = False Then

		For $i = 0 To $cpoint - 1

			$cits = 0
			For $p = 0 To $cplayer - 1

				$index = $p = $cplayer - 1? 0 : $p + 1

				$point1 = $player.points[$p]
				$point2 = $player.points[$index]
				$intersect = _IsIntersectLine(-100000, -100000, $node.parent.x + $node.points[$i].x, $node.parent.y + $node.points[$i].y, $point1.x, $point1.y, $point2.x, $point2.y)

				If IsArray($intersect) Then $cits += 1
			Next

			If $cits > 0 And Mod($cits, 2) = 1 Then
				$isIts = True
				ExitLoop
			EndIf

		Next
	EndIf


	If $isIts Then

		; calculate which line is the closet
		For $i = 0 To $cpoint - 1


			$index = $i = $cpoint - 1? 0 : $i + 1

			$_x1 = $node.parent.x + $node.points[$i].x
			$_y1 = $node.parent.y + $node.points[$i].y
			$_x2 = $node.parent.x + $node.points[$index].x
			$_y2 = $node.parent.y + $node.points[$index].y

			$distIts = Sqrt(($_x1 - $_x2) ^ 2 + ($_y1 - $_y2) ^ 2)
			$distClose = Sqrt(($_x1 - $player.centerX) ^ 2 + ($_y1 - $player.centerY) ^ 2)
			$distClose += Sqrt(($_x2 - $player.centerX) ^ 2 + ($_y2 - $player.centerY) ^ 2)
			$distClose = $distClose - $distIts

			If $i = 0 Or $distRe > $distClose Then

				$distRe = $distClose
				$distance = $distIts
				$pointIts1 = $node.points[$i]
				$pointIts2 = $node.points[$index]
			EndIf
		Next

;~ 		$_x1 = $node.parent.x + $pointIts1.x - $player.parent.camera.x
;~ 		$_y1 = $node.parent.y + $pointIts1.y - $player.parent.camera.y
;~ 		$_x2 = $node.parent.x + $pointIts2.x - $player.parent.camera.x
;~ 		$_y2 = $node.parent.y + $pointIts2.y - $player.parent.camera.y

;~ 			_GDIPlus_GraphicsDrawLine($player.parent.context, $_x1, $_y1, $_x2, $_y2,  _GDIPlus_PenCreate(0xFFFF0000, 10))
		$DX = ($pointIts1.x - $pointIts2.x) / $distance
		$DY = ($pointIts1.y - $pointIts2.y) / $distance

		$dot = $player.accelX * - $DY + $player.accelY * $DX
		$DX2 = $player.accelX - 2 * $dot * -$DY
		$DY2 = $player.accelY - 2 * $dot * $DX

		$aPoints[0] = $DX2
		$aPoints[1] = $DY2

		Return $aPoints

	EndIf

	Return False
EndFunc




Func _Polygon_Centeroid($oPoints)

	Local $len = UBound($oPoints), $centeroid[2], $x0, $y0, $x1, $y1, $a, $idx, $signed

	If $len < 3 Then Return False

	Local $points[$len][2]

	For $i = 0 To $len - 1

		$points[$i][0] = $oPoints[$i].x
		$points[$i][1] = $oPoints[$i].y
	Next


	For $i = 0 To $len - 1

		$idx = Mod(($i + 1), $len)
		$x0 = $points[$i][0]
		$y0 = $points[$i][1]
		$x1 = $points[$idx][0]
		$y1 = $points[$idx][1]

		$a = $x0 * $y1 - $x1 * $y0
		$signed += $a

		$centeroid[0] += ($x0 + $x1) * $a
		$centeroid[1] += ($y0 + $y1) * $a

	Next

	$signed *= 0.5

	$centeroid[0] /= 6 * $signed
	$centeroid[1] /= 6 * $signed

	Return $centeroid
EndFunc


Func _IsIntersectLine($pX1, $pY1, $pX2, $pY2, $rX1, $rY1, $rX2, $rY2)

	Local $A1, $B1, $C1, $A2, $B2, $C2, $det, $intersect[2], $vx0, $vy0, $vx1, $vy1

	$A1 = $pY2 - $pY1
	$B1 = $pX1 - $pX2
	$C1 = $A1 * $pX1 + $B1 * $pY1
	$A2 = $rY2 - $rY1
	$B2 = $rX1 - $rX2
	$C2 = $A2 * $rX1 + $B2 * $rY1

	$det = $A1 * $B2 - $A2 * $B1

	If $det = 0 Then Return False

	$intersect[0] = ($B2 * $C1 - $B1 * $C2) / $det
	$intersect[1] = ($A1 * $C2 - $A2 * $C1) / $det
	$vx0 = ($intersect[0] - $pX1) / ($pX2 - $pX1)
	$vy0 = ($intersect[1] - $pY1) / ($pY2 - $pY1)
	$vx1 = ($intersect[0] - $rX1) / ($rX2 - $rX1)
	$vy1 = ($intersect[1] - $rY1) / ($rY2 - $rY1)

	Return ((($vx0 >= 0 And $vx0 <= 1) Or ($vy0 >= 0 And $vy0 <= 1)) And (($vx1 > 0 And $vx1 < 1) Or ($vy1 > 0 And $vy1 < 1))) ? $intersect : False

EndFunc

;~ Func __GetClosetLine($x, $y, $points)

;~ 	Local $distance, $closet = -100, $index

;~ 	For $i = 0 To UBound($points) - 1

;~ 		$distance = Sqrt(($x - $points[$i].x) ^ 2 + ($y - $points[$i].y) ^ 2)

;~ 		If $closet < $distance Then
;~ 			$closet = $distance
;~ 			$index = 0
;~ 		Next
;~ 	Next

;~ EndFunc