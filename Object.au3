#include-once
#include "_header.au3"

Global $__ObjProps[0]
__ArrayAppend($__ObjProps, "name")
__ArrayAppend($__ObjProps, "cBk")
__ArrayAppend($__ObjProps, "cGlow")
__ArrayAppend($__ObjProps, "color")
__ArrayAppend($__ObjProps, "lineW")
__ArrayAppend($__ObjProps, "x")
__ArrayAppend($__ObjProps, "y")
__ArrayAppend($__ObjProps, "nodes")
__ArrayAppend($__ObjProps, "boxs")

Global $__NodeProps[0]
__ArrayAppend($__NodeProps, "x1")
__ArrayAppend($__NodeProps, "y1")
__ArrayAppend($__NodeProps, "x2")
__ArrayAppend($__NodeProps, "y2")

Global $__BoxProps[0]
__ArrayAppend($__BoxProps, "x")
__ArrayAppend($__BoxProps, "y")
__ArrayAppend($__BoxProps, "w")
__ArrayAppend($__BoxProps, "h")

Func Object($obj, $parent)

	If $obj.__check($__ObjProps) = False Then Return print("Failed to initalize object", 2)

	$obj.__add("parent", $parent)
	$obj.__add("isGlow", False)
	$obj.__add("tGlow", TimerInit())
	$obj.__method("draw", "_Object_Draw")
	$obj.__method("glow", "_Object_Glow")

	Local $name = $obj.name

	For $node In $obj.nodes.__keys

		If $node.__check($__NodeProps) = False Or IsInt( UBound($node.__keys) / 2) = False Then
			$obj = False
			Return print("Failed to initalize node on object: " & $name, 2)
		EndIf

		$node.__method("draw", "_Node_Draw")

	Next

	For $box In $obj.boxs.__keys

		If $box.__check($__BoxProps) = False Or IsInt( UBound($box.__keys) / 2) = False Then
			$obj = False
			Return print("Failed to initalize box on object: " & $name, 2)
		EndIf

		$box.__method("draw", "_Box_Draw")

	Next

	$obj.__add("pen", _GDIPlus_PenCreate($obj.color, $obj.lineW))
	$obj.__add("penGlow", _GDIPlus_PenCreate($obj.cGlow, $obj.lineW))
	$obj.__add("brush", _GDIPlus_BrushCreateSolid($obj.cBk))
EndFunc

Func _Object_Glow($self)

	$self.isGlow = True
	$self.tGlow = TimerInit()

EndFunc

Func _Object_Draw($self)

	Local $engine = $self.parent.parent, $isDraw = False
	Local $x1, $y1, $x2, $y2, $count, $aPoints[0][2]

	For $node in $self.nodes.__keys

		$count = $node.__len / 2

		$isDraw = False

		ReDim $aPoints[$count + 1][2]
		$aPoints[0][0] = $count
		For $i = 1 To $count


			$x1 = $self.x + $node.__keys[($i - 1) * 2] - $engine.camera.x
			$y1 = $self.y + $node.__keys[$i * 2 - 1]- $engine.camera.y

			If $x1 >= 0 And $x1 <= $engine.w And $y1 >= 0 And $y1 <= $engine.h Then $isDraw = True

			If $i = $count Then

				$x2 = $self.x + $node.__keys[0] - $engine.camera.x
				$y2 = $self.y + $node.__keys[1] - $engine.camera.y
			Else
				$x2 = $self.x + $node.__keys[($i - 1) * 2 + 2] - $engine.camera.x
				$y2 = $self.y + $node.__keys[$i * 2 + 1] - $engine.camera.y
			EndIf

			$aPoints[$i][0] = $x1
			$aPoints[$i][1] = $y1
		Next

		If $isDraw Then

			_GDIPlus_GraphicsDrawPolygon($engine.context, $aPoints, $self.pen)
			_GDIPlus_GraphicsFillPolygon($engine.context, $aPoints, $self.brush)

			If $self.isGlow Then

			_GDIPlus_GraphicsDrawPolygon($engine.context, $aPoints, $self.penGlow)
				If TimerDiff($self.tGlow) > 500 Then $self.isGlow = False
			EndIf
		EndIf

	Next
EndFunc
