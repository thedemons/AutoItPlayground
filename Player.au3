#include-once
#include "_header.au3"

Global Const $__PLAYER_IDLE = 0
Global Const $__PLAYER_FLOAT = 2

Global $__PlayerProps[0]
__ArrayAppend($__PlayerProps, "name")
__ArrayAppend($__PlayerProps, "color")
__ArrayAppend($__PlayerProps, "cBk")
__ArrayAppend($__PlayerProps, "cW")
__ArrayAppend($__PlayerProps, "jump")
__ArrayAppend($__PlayerProps, "weight")
__ArrayAppend($__PlayerProps, "speed")
__ArrayAppend($__PlayerProps, "walk")
__ArrayAppend($__PlayerProps, "run")
__ArrayAppend($__PlayerProps, "gravity")
__ArrayAppend($__PlayerProps, "gravityspeed")
__ArrayAppend($__PlayerProps, "health")
__ArrayAppend($__PlayerProps, "weapon")
__ArrayAppend($__PlayerProps, "x")
__ArrayAppend($__PlayerProps, "y")
__ArrayAppend($__PlayerProps, "w")
__ArrayAppend($__PlayerProps, "h")

Func Player($data, $parent)

	Local $self = Json($data)
	If $self.__check($__PlayerProps) = False Then Return print("Failed to initalize player", 2)

	$self.__add("layout", _GDIPlus_RectFCreate(0,0, 200,30))
	$self.__add("parent", $parent)
	$self.__add("prevX", $self.x)
	$self.__add("prevY", $self.y)

	$self.__add("centerX")
	$self.__add("centerY")
	$self.__add("accelX")
	$self.__add("accelY")
	$self.__add("accelZ")
	$self.__add("accelRate")
	$self.__add("accelRateY")
	$self.__add("jumpcount")

	$self.__method("draw", "_Player_Draw")
	$self.__method("update", "_Player_Update")
	$self.__method("init", "_Player_Init")
	$self.__method("move", "_Player_Move")
	$self.__method("moveL", "_Player_MoveL")
	$self.__method("moveR", "_Player_MoveR")
	$self.__method("moveU", "_Player_MoveU")
	$self.__method("moveD", "_Player_MoveD")

	$self.color = _GDIPlus_PenCreate($self.color, $self.cW)
	$self.cBk = _GDIPlus_BrushCreateSolid($self.cBk)
	$self.parent = $parent

	$self.init

	Return $self
EndFunc

Func _Player_Init($self)

	Local $points[4]

	$points[0] = IDispatch()
	$points[0].__add("x", $self.x)
	$points[0].__add("y", $self.y)
	$points[1] = IDispatch()
	$points[1].__add("x", $self.x + $self.w)
	$points[1].__add("y", $self.y)
	$points[2] = IDispatch()
	$points[2].__add("x", $self.x + $self.w)
	$points[2].__add("y", $self.y + $self.h)
	$points[3] = IDispatch()
	$points[3].__add("x", $self.x)
	$points[3].__add("y", $self.y + $self.h)

	$self.__add("points", $points)
EndFunc

Func _Player_MoveL($self, $isRun = False)
	$self.move($isRun ? -$self.run : -$self.walk, 0, 0, $self.speed)
EndFunc

Func _Player_MoveR($self, $isRun = False)
	$self.move($isRun ? $self.run : $self.walk, 0, 0, $self.speed)
EndFunc

Func _Player_MoveU($self)

;~ 	If $self.state = $__PLAYER_IDLE Then $self.jumpcount = 0
;~ 	If $self.jumpcount >= 2 Then Return

	$self.accelY = -$self.jump
;~ 	$self.jumpcount += 1
;~ 	ConsoleWrite
EndFunc

Func _Player_Move($self, $x = 0, $y = 0, $z = 0, $speed = -1)

	$self.accelX += $x
	$self.accely += $y
	$self.accelZ += $z / 1000
	$self.accelRate = $speed = -1 ? $self.accelRate : $speed
EndFunc

Func _Player_Draw($self)

	Local $x = ($self.x - $self.parent.camera.x) * $self.parent.camera.z
	Local $y = ($self.y  - $self.parent.camera.y)  * $self.parent.camera.z

	_GDIPlus_GraphicsFillEllipse($self.parent.context, $x, $y, $self.w * $self.parent.camera.z, $self.h * $self.parent.camera.z, $self.cBk)
	_GDIPlus_GraphicsDrawEllipse($self.parent.context, $x + $self.accelX, $y + $self.accely, $self.w * $self.parent.camera.z, $self.h * $self.parent.camera.z, $self.color)

	$self.layout.X = $x - 20
	$self.layout.Y = $y - 25
	_GDIPlus_GraphicsDrawStringEx($self.parent.context, $self.name, $self.parent.font, $self.layout, $self.parent.format, $self.parent.brushtext)
EndFunc

Func _Player_Update($self)

	Local $parent = $self.parent, $center = _Polygon_Centeroid($self.points)

	If IsArray($center) Then

		$self.centerX = $center[0]
		$self.centerY = $center[1]
	EndIf


	; accelarate
	$self.x += $self.accelX
	$self.y += $self.accelY
	$self.z += $self.accelZ



	Local $points = $self.points
	$points[0].x = $self.x
	$points[0].y = $self.y
	$points[1].x = $self.x + $self.w
	$points[1].y = $self.y
	$points[2].x = $self.x + $self.w
	$points[2].y = $self.y + $self.h
	$points[3].x = $self.x
	$points[3].y = $self.y + $self.h

	If $self.accelRate > 0 Then
		$self.accelX -= $self.accelX / $self.accelRate
		$self.accelZ -= $self.accelZ / $self.accelRate
	EndIf

	If $self.accelRateY > 0 Then $self.accelY -= $self.accelY / $self.accelRateY

	If $self.accelX < 0.2 And -$self.accelX < 0.2 Then $self.accelX = 0
	If $self.accelY < 0.2 And -$self.accelY < 0.2  Then $self.accelY = 0
	If $self.accelZ < 0.2 And -$self.accelZ < 0.2  Then $self.accelZ = 0

;~ 	$self.accelY += $self.gravity
	$self.accelRateY = 30
	; enviroment boundary
	If $self.x < 0 Then

		$self.x = 0
		$self.accelX = -$self.accelX / $self.weight * 10

	ElseIf $self.y < 0 Then

		$self.y = 0
		$self.accelY = -$self.accelY / $self.weight * 10

	ElseIf $self.x + $self.w > $parent.env.w Then

		$self.x = $parent.env.w - $self.w
		$self.accelX = -$self.accelX / $self.weight * 10

	ElseIf $self.y + $self.h > $parent.env.h Then

		$self.y = $parent.env.h - $self.h
		If $self.state = $__PLAYER_FLOAT Then $self.accelY = -$self.accelY / $self.weight * 10
		$self.state = $__PLAYER_IDLE

	EndIf

	;gravity

;~ 	For $obj In $parent.env.objs.__keys

;~ 		For $box In $obj.boxs.__keys

;~ 			If $box.w = 0 Then ContinueLoop

;~ 			Local $boxX = $obj.x + $box.x
;~ 			Local $boxY = $obj.y + $box.y

;~ 			If $self.x + $self.w > $boxX And $self.x < $boxX + $box.w Then

;~ 				If $self.y + $self.h > $obj.y -1 + $box.y And $self.y < $obj.y - 1 + $box.y + $box.h Then

;~ 					Local $bound = __getminpos($self, $boxX, $boxY, $box.w, $box.h)

;~ 					$obj.glow
;~ 					If $bound <> 3 Then ConsoleWrite($bound)
;~ 					Switch $bound
;~ 						Case 0 ; left
;~ 							$self.accelX = -$self.accelX / $self.weight * 20
;~ 							$self.x = $boxX - $self.w

;~ 						Case 1 ; top
;~ 							$self.accelY = -$self.accelY / $self.weight * 20
;~ 							$self.y = $boxY + $box.h + 1

;~ 						Case 2 ; right
;~ 							$self.x = $boxX + $box.w + 2
;~ 							$self.accelX = -$self.accelX / $self.weight * 20

;~ 						Case 3 ; bottom
;~ 							$self.y = $boxY - $self.h + 1
;~ 							If $self.state = $__PLAYER_FLOAT Then $self.accelY = -$self.accelY / $self.weight * 10

;~ 							$self.state = $__PLAYER_IDLE

;~ 					EndSwitch
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	Next

	Local $movex, $movey, $points = $self.points, $rebound[2], $reboundcount = 0, $reboundX, $reboundY
	For $obj In $parent.env.objs.__keys

		If $self.x + $self.w >= $obj.x And $self.x <= $obj.x + $obj.w And $self.y + $self.h >= $obj.y And $self.y <= $obj.y + $obj.h Then

			For $node In $obj.nodes.__keys

				Local $its = _IsIntersect($self, $node)

				If IsArray($its) Then

					$reboundcount += 1
					$rebound[0] += $its[0]
					$rebound[1] += $its[1]
				EndIf
			Next
		EndIf
	Next

	If $reboundcount >= 1 Then

		$self.y -= $self.accelY
		If ($self.accelX <= 0 And $rebound[0] >= 0) Or ($self.accelX >= 0 And $rebound[0] <= 0) Then
			$self.accelX = $rebound[0] / 2
		Else
			$self.accelX = $rebound[0]
		EndIf
		If ($self.accelY <= 0 And $rebound[1] >= 0) Or ($self.accelY >= 0 And $rebound[1] <= 0) Then
			$self.accelY = $rebound[1] / 2
		Else
			$self.accelY = $rebound[1]
		EndIf

;~ 		If __positive($self.accelX) > 3 Then $self.accelY *= 1.5
;~ 		If $self.accelY < 0 And $self.accelY > -6 then $self.accelY /= 2
		If $self.accelY < 0 And $self.accelY > -3 then $self.accelY = 0

		$self.x = $self.prevX + $self.accelX
		$self.y = $self.prevY + $self.accelY

;~ 					_GDIPlus_GraphicsDrawEllipse($parent.context, $self.x + $self.accelX * 4 - $parent.camera.x, $self.Y + $self.accelY * 4  - $parent.camera.y, 50, 50, $red)
;~ 		$self.accelX /= 2
;~ 		$self.accelY /= 2
	Else
		$self.prevX = $self.x
		$self.prevY = $self.y
	$self.accelY += $self.gravity
	EndIf
	$self.state = $__PLAYER_FLOAT
EndFunc

Func __getminpos($self, $objx, $objy, $objw, $objh)

	; left relative
	If $objx > $self.x And $objx < $self.x + $self.w And $self.accelX > 0 Then

		Return 0
	EndIf

;~ 	; right relative
;~ 	If $objx + $objw > $self.x And $objx + $objw < $self.x + $self.w And $objx + $objw - $self.x < $self.w / 2 And $self.accelX <= 0 Then

;~ 		If $self.y + $self.h >= $objy And $self.y <= $objy + $objh Then Return 2
;~ 	EndIf

;~ 	; bottom
	If $objy + $objh > $self.y + $self.h  Then Return 3

	Return 1
EndFunc


Func __positive($x)
	Return $x > 0 ? $x : -$x
EndFunc