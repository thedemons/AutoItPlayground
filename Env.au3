#include-once
#include "_header.au3"

Global $__EnvProps[0]

__ArrayAppend($__EnvProps, "mapid")
__ArrayAppend($__EnvProps, "w")
__ArrayAppend($__EnvProps, "h")
__ArrayAppend($__EnvProps, "gridsize")
__ArrayAppend($__EnvProps, "gridw")
__ArrayAppend($__EnvProps, "cBk")
__ArrayAppend($__EnvProps, "color")
__ArrayAppend($__EnvProps, "objs")

Func Enviroment($data, $parent)

	Local $self = Json($data)

	If $self.__check($__EnvProps) = False Then Return print("Failed to initalize enviroment", 2)

	_AutoItObject_AddProperty($self, "parent")
	_AutoItObject_AddMethod($self, "init", "_Env_Init")
	_AutoItObject_AddMethod($self, "draw", "_Env_Draw")

	$self.parent = $parent
	$self.init

	Return $self
EndFunc

Func _Env_Draw($self)

	Local $parent = $self.parent, $x1, $y1, $x2, $y2

	; left line
	If $parent.camera.x <= 0 And $parent.camera.x + $parent.w > 0 Then

		$x1 = -$parent.camera.x
		$y1 = $parent.camera.y >= 0 ? 0 : -$parent.camera.y
		$x2 = $x1
		$y2 = $parent.camera.y + $parent.h < $parent.env.h ? $parent.h : $parent.env.h - $parent.camera.y
		_GDIPlus_GraphicsDrawLine($parent.context, $x1 * $parent.camera.z, $y1 * $parent.camera.z, $x2 * $parent.camera.z, $y2, $self.color)
	EndIf

	; right line
	If $parent.camera.x <= $parent.env.w And $parent.camera.x + $parent.w > $parent.env.w Then

		$x1 = $parent.env.w - $parent.camera.x
		$y1 = $parent.camera.y >= 0 ? 0 : -$parent.camera.y
		$x2 = $x1
		$y2 = $parent.camera.y + $parent.h < $parent.env.h ? $parent.h : $parent.env.h - $parent.camera.y
		_GDIPlus_GraphicsDrawLine($parent.context, $x1 * $parent.camera.z, $y1 * $parent.camera.z, $x2 * $parent.camera.z, $y2, $self.color)
	EndIf

	; top line
	If $parent.camera.y <= 0 And $parent.camera.y + $parent.h > 0 Then
		$x1 = $parent.camera.x >= 0 ? 0 : -$parent.camera.x
		$y1 = -$parent.camera.y
		$x2 = $parent.camera.x + $parent.w < $parent.env.w ? $parent.w : $parent.env.w - $parent.camera.x
		$y2 = $y1
		_GDIPlus_GraphicsDrawLine($parent.context, $x1 * $parent.camera.z, $y1 * $parent.camera.z, $x2, $y2 * $parent.camera.z, $self.color)
	EndIf

	; bottom line
	If $parent.camera.y <= $parent.env.h And $parent.camera.y + $parent.h > $parent.env.h Then
		$x1 = $parent.camera.x >= 0 ? 0 : -$parent.camera.x
		$y1 = $parent.env.h - $parent.camera.y
		$x2 = $parent.camera.x + $parent.w < $parent.env.w ? $parent.w : $parent.env.w - $parent.camera.x
		$y2 = $y1
		_GDIPlus_GraphicsDrawLine($parent.context, $x1 * $parent.camera.z, $y1 * $parent.camera.z, $x2, $y2 * $parent.camera.z, $self.color)
	EndIf
	For $obj In $self.objs.__keys
		_Object_Draw($obj)
	Next
EndFunc

Func _Env_Init($self)

	$self.color = _GDIPlus_PenCreate($self.color, $self.gridw)

	For $obj In $self.objs.__keys
		Object($obj, $self)
	Next
EndFunc