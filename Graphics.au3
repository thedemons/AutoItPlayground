#include-once
#include <_header.au3>

Func _Graphic($parent)

	Local $self = IDispatch()

	$self.__add("parent", $parent)
	$self.__add("polygons", IDispatch())
	$self.__add("cursor")
	$self.__method("update", "_Graphic_Update")

	$self.__method("polygon", "_Graphic_Polygon")

	$self.polygons.__method("draw", "_Graphic_Polygon_Draw")
	$self.polygons.__add("parent", $self)
	$self.polygons.__add("isHolding", False)
	Return $self
EndFunc

Func _Graphic_Update($self)

	$self.cursor = GUIGetCursorInfo($self.parent.gui)

	$self.polygons.draw

EndFunc

Func _Graphic_Polygon($self, $points, $lineW = 2, $color = 0xFF00FF00, $cBk = 0x33FFFFFF, $size = 16, $cPoint = 0x9900AA00, $cPointHover = 0xFF00FF00)

	If UBound($points) < 3 Then Return print("Invalid polygon", 2)

	; checking
	For $i = 0 to UBound($points) - 1

		Local $tmp = $points[$i]
		If Execute("$tmp.x") = "" Or Execute("$tmp.y") = "" Then Return print("Invalid polygon", 2)

		$points[$i].__add("isAttach", False)
	Next

	Local $polygon = IDispatch()

	$polygon.__add("parent",  $self.polygons)
	$polygon.__add("points",  $points)
	$polygon.__add("size",  $size)
	$polygon.__add("color", _GDIPlus_PenCreate($color, $lineW))
	$polygon.__add("cBk",  _GDIPlus_BrushCreateSolid($cBk))
	$polygon.__add("cPoint",  _GDIPlus_BrushCreateSolid($cPoint))
	$polygon.__add("cPointHover",  _GDIPlus_BrushCreateSolid($cPointHover))
	$polygon.__method("draw", "_Graphic_PolygonPoint_Draw")
	$self.polygons.__add("polygon", $polygon)

	Return $polygon
EndFunc

Func _Graphic_Polygon_Draw($self)

	For $polygon In $self.__keys
		If IsObj($polygon) And $polygon.__check("points") Then $polygon.draw
	Next

EndFunc

Func _Graphic_PolygonPoint_Draw($self)

	Local $x, $y, $color, $cursor = $self.parent.parent.cursor
	Local $len = UBound($self.points), $aPoints[$len + 1][2], $isHolding = False

	$aPoints[0][0] = $len
	For $i = 0 To $len - 1

		$aPoints[$i + 1][0] = $self.points[$i].x
		$aPoints[$i + 1][1] = $self.points[$i].y
	Next
	_GDIPlus_GraphicsFillPolygon($self.parent.parent.parent.context, $aPoints, $self.cBk)
	_GDIPlus_GraphicsDrawPolygon($self.parent.parent.parent.context, $aPoints, $self.color)
	For $i = 0 to $len - 1

		$color = $self.cPoint
		If IsArray($cursor) Then

			If $self.points[$i].isAttach Then

				$isHolding = True
				Local $points = $self.points
				$points[$i].x = $cursor[0]
				$points[$i].y = $cursor[1]
				If $cursor[2] = 0 Then
					$points[$i].isAttach = False
					$self.parent.isHolding = False
				EndIf
				$self.points = $points
			EndIf

			$x = $self.points[$i].x - $self.size / 2
			$y = $self.points[$i].y - $self.size / 2

			If $self.parent.isHolding = False And $cursor[0] >= $x And $cursor[0] <= $x + $self.size And $cursor[1] >= $y And $cursor[1] <= $y + $self.size Then

				$color = $self.cPointHover
				If $cursor[2] = 1 Then

					Local $points = $self.points
					 $points[$i].isAttach = True
					 $self.points = $points
					 $self.parent.isHolding = True
				EndIf
			EndIf
		EndIf

		_GDIPlus_GraphicsDrawString($self.parent.parent.parent.context, $i, $x, $y - 20)
		_GDIPlus_GraphicsFillRect($self.parent.parent.parent.context, $x, $y, $self.size, $self.size, $color)

	Next

EndFunc