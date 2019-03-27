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
__ArrayAppend($__ObjProps, "w")
__ArrayAppend($__ObjProps, "h")
__ArrayAppend($__ObjProps, "nodes")

Global $__NodeProps[0]
__ArrayAppend($__NodeProps, "x1")
__ArrayAppend($__NodeProps, "y1")
__ArrayAppend($__NodeProps, "x2")
__ArrayAppend($__NodeProps, "y2")


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

		$node.__add("parent", $obj)
		$node.__method("draw", "_Node_Draw")
		$node.__method("init", "_Node_Init")
		$node.init

	Next


	$obj.__add("pen", _GDIPlus_PenCreate($obj.color, $obj.lineW))
	$obj.__add("penGlow", _GDIPlus_PenCreate($obj.cGlow, $obj.lineW))
	$obj.__add("brush", _GDIPlus_BrushCreateSolid($obj.cBk))
EndFunc

Func _Node_Init($self)

	Local $x, $y

	$count = $self.__len / 2

	Local $points[$count]

	For $i = 0 To $count - 1

		$x = $self.__keys[$i * 2]
		$y = $self.__keys[$i * 2 + 1]

		$points[$i] = IDispatch()
		$points[$i].__add("x", $x)
		$points[$i].__add("y", $y)
	Next

	$self.__add("points", $points)
EndFunc

Func _Node_Draw($self)

	Local $engine = $self.parent.parent.parent, $obj = $self.parent, $isDraw = False
	Local $x1, $y1, $x2, $y2, $count

	$count = UBound($self.points) - 1

	Local $aPoints[$count + 2][2]
	$aPoints[0][0] = $count + 1

	For $i = 0 To $count


		$x1 = $obj.x + $self.points[$i].x - $engine.camera.x
		$y1 = $obj.y + $self.points[$i].y - $engine.camera.y

		$x1 *= $engine.camera.z
		$y1 *= $engine.camera.z

		If $x1 >= 0 And $x1 <= $engine.w And $y1 >= 0 And $y1 <= $engine.h Then $isDraw = True

		If $i = $count Then

			$x2 = $obj.x + $self.points[0].x - $engine.camera.x
			$y2 = $obj.y + $self.points[0].y - $engine.camera.y
		Else
			$x2 = $obj.x + $self.points[$i + 1].x - $engine.camera.x
			$y2 = $obj.y + $self.points[$i + 1].y - $engine.camera.y
		EndIf

		$x2 *= $engine.camera.z
		$y2 *= $engine.camera.z
		$aPoints[$i + 1][0] = $x1
		$aPoints[$i + 1][1] = $y1
	Next

	If $isDraw Then

		_GDIPlus_GraphicsDrawPolygon($engine.context, $aPoints, $obj.pen)
		_GDIPlus_GraphicsFillPolygon($engine.context, $aPoints, $obj.brush)

		If $obj.isGlow Then

		_GDIPlus_GraphicsDrawPolygon($engine.context, $aPoints, $obj.penGlow)
			If TimerDiff($obj.tGlow) > 500 Then $obj.isGlow = False
		EndIf
	EndIf

EndFunc

Func _Object_Glow($self)

	$self.isGlow = True
	$self.tGlow = TimerInit()

EndFunc

Func _Object_Draw($self)

	Local $engine = $self.parent.parent, $isDraw = False
	Local $x1, $y1, $x2, $y2, $count, $aPoints[0][2], $points

	For $node in $self.nodes.__keys

		_Node_Draw($node)

	Next
EndFunc
