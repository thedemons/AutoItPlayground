#include-once
#include "_header.au3"

Global Const $__CAM_IDLE = 0
Global Const $__CAM_MOVE = 1
Global Const $__CAM_FLOAT = 2

Func Camera($parent)

	Local $self = _AutoItObject_Create()

	_AutoItObject_AddProperty($self, "parent")
	_AutoItObject_AddProperty($self, "x")
	_AutoItObject_AddProperty($self, "y")
	_AutoItObject_AddProperty($self, "z")

	_AutoItObject_AddProperty($self, "desX")
	_AutoItObject_AddProperty($self, "desY")
	_AutoItObject_AddProperty($self, "desZ")

	_AutoItObject_AddProperty($self, "accelX")
	_AutoItObject_AddProperty($self, "accelY")
	_AutoItObject_AddProperty($self, "accelZ")
	_AutoItObject_AddProperty($self, "accelRate")

	_AutoItObject_AddProperty($self, "oriX")
	_AutoItObject_AddProperty($self, "oriY")
	_AutoItObject_AddProperty($self, "oriZ")

	_AutoItObject_AddProperty($self, "state")
	_AutoItObject_AddProperty($self, "speed")
	_AutoItObject_AddProperty($self, "time")
	_AutoItObject_AddProperty($self, "attach")

	_AutoItObject_AddMethod($self, "move", "_Camera_Move")
	_AutoItObject_AddMethod($self, "moveto", "_Camera_MoveTo")
	_AutoItObject_AddMethod($self, "attachto", "_Camera_AttachTo")
	_AutoItObject_AddMethod($self, "update", "_Camera_Update")

	$self.x = 0
	$self.y = 0
	$self.z = 1
	$self.parent = $parent
	$self.state = $__CAM_IDLE
	Return $self
EndFunc

Func _Camera_Move($self, $x = 0, $y = 0, $z = 0, $speed = 15)

	$self.accelX += $x
	$self.accely += $y
	$self.accelZ += $z
	$self.accelRate = $speed
	$self.state = $__CAM_FLOAT
EndFunc

Func _Camera_AttachTo($self, $player)

	$self.attach = $player
EndFunc

Func _Camera_MoveTo($self, $x, $y, $z = -1, $speed = 15)

	$self.oriX = $self.x
	$self.oriY = $self.y
	$self.oriZ = $self.z

	$self.desX = $x
	$self.desY = $y
	$self.desZ = $z = -1 ? $self.z : $z


	$self.state = $__CAM_MOVE
	$self.speed = $speed
	$self.time = TimerInit()
EndFunc

Func _Camera_Update($self)

	Switch $self.state

		Case $__CAM_MOVE

			Local $Accel = TimerDiff($self.time) / ($self.speed * 100)
			If $Accel >= 1 Then

				$self.x = $self.desX
				$self.y = $self.desY
				$self.z = $self.desZ
				$self.state = $__CAM_IDLE
				Return
			EndIf

			$self.x = $self.oriX + ($self.desX - $self.oriX) * $Accel
			$self.y = $self.oriY + ($self.desY - $self.oriY) * $Accel
			$self.z = $self.oriZ + ($self.desZ - $self.oriZ) * $Accel

		Case $__CAM_FLOAT

			$self.x += $self.accelX
			$self.y += $self.accelY
			$self.z += $self.accelZ

			$self.accelX -= $self.accelX / $self.accelRate
			$self.accelY -= $self.accelY / $self.accelRate
			$self.accelZ -= $self.accelZ / $self.accelRate

			If $self.accelX < 0.1 And -$self.accelX < 0.1 Then $self.accelX = 0
			If $self.accelY < 0.1 And -$self.accelY < 0.1  Then $self.accelY = 0
			If $self.accelZ < 0.1 And -$self.accelZ < 0.1  Then $self.accelZ = 0

	EndSwitch

	If IsObj($self.attach) Then

;~ 		Local $z = ($self.attach.accelX + $self.attach.accelY) / $self.attach.run
;~ 		If $self.z = 1 Then
;~ 			Local $speed = $z < 5 ? 5 : 2
;~ 			$z = $z < 5 ? 1 : 5 / $z
;~ 		Else
;~ 			$z = $z < 5 ? $self.z + 0.1 : -1
;~ 			If $z > 1 Then $z = 1
;~ 		EndIf

		$self.moveto($self.attach.x - $self.parent.w / 2, $self.attach.y - $self.parent.h / 2, -1, 3)
	EndIf
;~ 	If $self.x < 0 Then $self.x = 0
;~ 	If $self.y < 0 Then $self.y = 0
;~ 	If $self.x + $self.parent.w > $self.parent.env.w Then $self.x = $self.parent.env.w - $self.parent.w
;~ 	If $self.y + $self.parent.h > $self.parent.env.h Then $self.y = $self.parent.env.h - $self.parent.h

EndFunc