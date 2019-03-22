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

	$self.__add("accelX")
	$self.__add("accelY")
	$self.__add("accelZ")
	$self.__add("accelRate")
	$self.__add("accelRateY")
	$self.__add("jumpcount")

	$self.__method("draw", "_Player_Draw")
	$self.__method("update", "_Player_Update")
	$self.__method("move", "_Player_Move")
	$self.__method("moveL", "_Player_MoveL")
	$self.__method("moveR", "_Player_MoveR")
	$self.__method("moveU", "_Player_MoveU")
	$self.__method("moveD", "_Player_MoveD")

	$self.color = _GDIPlus_PenCreate($self.color, $self.cW)
	$self.cBk = _GDIPlus_BrushCreateSolid($self.cBk)
	$self.parent = $parent

	Return $self
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

;~ 	If $x > 0 And $self.x - $self.parent.camera.x > $self.parent.w / 2 Then $self.parent.camera.move($x, 0, 0, $speed)
;~ 	If $x < 0 And $self.x - $self.parent.camera.x < $self.parent.w / 2 Then $self.parent.camera.move($x, 0, 0, $speed)
;~ 	If $y > 0 And $self.y - $self.parent.camera.y > $self.parent.h / 2 Then $self.parent.camera.move(0, $y, 0, $speed)
;~ 	If $y < 0 And $self.y - $self.parent.camera.y < $self.parent.h / 2 Then $self.parent.camera.move(0, $y, 0, $speed)

	$self.accelX += $x
	$self.accely += $y
	$self.accelZ += $z / 1000
	$self.accelRate = $speed = -1 ? $self.accelRate : $speed
EndFunc

Func _Player_Draw($self)

	Local $x = $self.x - $self.parent.camera.x
	Local $y = $self.y  - $self.parent.camera.y

	_GDIPlus_GraphicsFillEllipse($self.parent.context, $x, $y, $self.w, $self.h, $self.cBk)
	_GDIPlus_GraphicsDrawEllipse($self.parent.context, $x + $self.accelX, $y + $self.accely, $self.w, $self.h, $self.color)

	$self.layout.X = $x - 20
	$self.layout.Y = $y - 25
	_GDIPlus_GraphicsDrawStringEx($self.parent.context, $self.name, $self.parent.font, $self.layout, $self.parent.format, $self.parent.brushtext)
EndFunc

Func _Player_Update($self)

	Local $parent = $self.parent

	; accelarate

	$self.x += $self.accelX
	$self.y += $self.accelY
	$self.z += $self.accelZ

	If $self.accelRate > 0 Then
		$self.accelX -= $self.accelX / $self.accelRate
		If $self.accelRateY > 0 Then $self.accelY -= $self.accelY / $self.accelRateY
		$self.accelZ -= $self.accelZ / $self.accelRate
	EndIf

	If $self.accelX < 0.2 And -$self.accelX < 0.2 Then $self.accelX = 0
	If $self.accelY < 0.2 And -$self.accelY < 0.2  Then $self.accelY = 0
	If $self.accelZ < 0.2 And -$self.accelZ < 0.2  Then $self.accelZ = 0

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
	If $self.state <> $__PLAYER_IDLE Then
		$self.accelY += $self.gravity
		$self.accelRateY = 0
	EndIf

	For $obj In $parent.env.objs.__keys

		For $box In $obj.boxs.__keys

			If $box.w = 0 Then ContinueLoop

			Local $boxX = $obj.x + $box.x
			Local $boxY = $obj.y + $box.y

			If $self.x + $self.w > $boxX And $self.x < $boxX + $box.w Then

				If $self.y + $self.h > $obj.y -1 + $box.y And $self.y < $obj.y - 1 + $box.y + $box.h Then

					Local $bound = __getminpos($self, $boxX, $boxY, $box.w, $box.h)

					$obj.glow
					If $bound <> 3 Then ConsoleWrite($bound)
					Switch $bound
						Case 0 ; left
							$self.x = $boxX - $self.w
							$self.accelX = -$self.accelX / $self.weight * 20

						Case 1 ; top
							$self.y = $boxY + $box.h + 1
							$self.accelY = -$self.accelY / $self.weight * 10

						Case 2 ; right
							$self.x = $boxX + $box.w + 2
							$self.accelX = -$self.accelX / $self.weight * 20

						Case 3 ; bottom
							$self.y = $boxY - $self.h + 1
							If $self.state = $__PLAYER_FLOAT Then $self.accelY = -$self.accelY / $self.weight * 10

							$self.state = $__PLAYER_IDLE
					EndSwitch

				EndIf
			EndIf
		Next
	Next

	$self.state = $__PLAYER_FLOAT
EndFunc

Func __getminpos($self, $objx, $objy, $objw, $objh)

	; left relative
	If $objx > $self.x And $objx < $self.x + $self.w And $self.x + $self.w - $objx < $self.w / 2 And $self.accelX > 0 Then

		If $self.y + $self.h > $objy And $self.y < $objy + $objh Then Return 0
	EndIf

	; right relative
	If $objx + $objw > $self.x And $objx + $objw < $self.x + $self.w And $objx + $objw - $self.x < $self.w / 2 And $self.accelX <= 0 Then

		If $self.y + $self.h > $objy And $self.y < $objy + $objh Then Return 2
	EndIf

	; bottom
	If $objy + $objh > $self.y + $self.h  Then Return 3

	Return 1
EndFunc


Func __positive($x)
	Return $x > 0 ? $x : -$x
EndFunc