#include-once
#include "_header.au3"

Global $__AllGUI[0]
Global $__SettingProps[0]

__ArrayAppend($__SettingProps, "w")
__ArrayAppend($__SettingProps, "h")
__ArrayAppend($__SettingProps, "cBk")


Func EngineStart($GUI)

	Local $self = _AutoItObject_Create()

	_AutoItObject_AddProperty($self, "GUIindex")
	_AutoItObject_AddProperty($self, "w")
	_AutoItObject_AddProperty($self, "h")
	_AutoItObject_AddProperty($self, "cBk")
	_AutoItObject_AddProperty($self, "hDC")
	_AutoItObject_AddProperty($self, "buffer")
	_AutoItObject_AddProperty($self, "context")
	_AutoItObject_AddProperty($self, "brushtext")
	_AutoItObject_AddProperty($self, "format")
	_AutoItObject_AddProperty($self, "font")

	_AutoItObject_AddProperty($self, "camera")
	_AutoItObject_AddProperty($self, "env")
	_AutoItObject_AddProperty($self, "time")
	_AutoItObject_AddProperty($self, "player")

	_AutoItObject_AddMethod($self, "init", "_Engine_Init")
	_AutoItObject_AddMethod($self, "enviroment", "_Engine_Env")
	_AutoItObject_AddMethod($self, "playerinit", "_Engine_PlayerInit")
	_AutoItObject_AddMethod($self, "draw", "_Engine_Draw")
	_AutoItObject_AddMethod($self, "drawBackground", "_Engine_DrawBackground")

	Local $Index = UBound($__AllGUI)
	ReDim $__AllGUI[$Index + 1]
	$__AllGUI[$Index] = $GUI
	$self.GUIindex = $Index

	Local $Info = FileRead($__fEngineSetting)
	If $self.init($Info) = False Then Return print("Failed to initalize engine", 2)

	$self.camera = Camera($self)
	$self.brushtext = _GDIPlus_BrushCreateSolid(0xFF00FF00)
	$self.format = _GDIPlus_StringFormatCreate()
    $self.font = _GDIPlus_FontCreate(_GDIPlus_FontFamilyCreate("Segoe UI"), 12, 2)


	Return $self
EndFunc
Global $testbrush = _GDIPlus_BrushCreateSolid(0xAAFFFFFF)
Func _Engine_Draw($self)

;~ 	_GDIPlus_GraphicsClear($self.context, $self.env.cBk)
	_WinAPI_BitBlt($self.buffer, 0, 0, $self.w, $self.h, $self.buffer, 0, 0, $self.env.cBk)

	$self.camera.update
	$self.player.update
	$self.env.draw
	$self.player.draw

	_GDIPlus_GraphicsFillRect($self.context, 3, 3, 200, 50, $testbrush)
	_GDIPlus_GraphicsDrawString($self.context, "FPS: " & Round(1000 / TimerDiff($self.time)), 5, 5)
	_GDIPlus_GraphicsDrawString($self.context, "Camera X: " & Round($self.camera.x, 2) & "   Y: " & Round($self.camera.y, 2), 5, 20)
	_GDIPlus_GraphicsDrawString($self.context, "Player X: " & Round($self.player.x, 2) & "   Y: " & Round($self.player.y, 2), 5, 35)
;~ 	_GDIPlus_GraphicsDrawImageRect($self.graphic, $self.bitmap, 0, 0, $self.w, $self.h)

	_WinAPI_BitBlt($self.hDC, 0, 0, $self.w, $self.h, $self.buffer, 0, 0, $SRCCOPY) ;blit drawn bitmap to GUI

	$self.time = TimerInit()
EndFunc

Func _Engine_DrawBackground($self, $img)

;~ 	Local $x = (($self.camera.x + $self.w) / $self.env.w) * $self.w / 2
;~ 	Local $y = (($self.camera.y + $self.h) / $self.env.h) * $self.h / 2

;~     _GDIPlus_GraphicsDrawImagePointsRect($self.context, $img, 0, 0, $self.w, 0, 0, $self.h, $self.camera.x, $self.camera.y, $self.w, $self.h)

	$x = -($self.camera.x - Floor($self.camera.x / $self.env.gridsize) * $self.env.gridsize)
	$y = -($self.camera.y - Floor($self.camera.y / $self.env.gridsize) * $self.env.gridsize)
	While $x < $self.w

		_GDIPlus_GraphicsDrawLine($self.context, $x, 0, $x, $self.h)
		$x += $self.env.gridsize * $self.camera.z
	WEnd
	While $y < $self.h

		_GDIPlus_GraphicsDrawLine($self.context, 0, $y, $self.w, $y)
		$y += $self.env.gridsize * $self.camera.z
	WEnd

EndFunc

Func _Engine_Init($self, $Info)

	Local $Setting = Json($Info)
	If $Setting.__check($__SettingProps) = False Then Return False

	Local $GUI = $__AllGUI[$self.GUIindex]
	$self.w = $Setting.w
	$self.h = $Setting.h
	$self.cBk = $Setting.cBk

	WinMove($GUI, "", (@DesktopWidth - $self.w) / 2, (@DesktopHeight - $self.h) / 2, $self.w, $self.h)

;~ 	$self.graphic = _GDIPlus_GraphicsCreateFromHWND($GUI)
;~ 	$self.bitmap = _GDIPlus_BitmapCreateFromGraphics($self.w, $self.h, $self.graphic)
;~ 	$self.context = _GDIPlus_ImageGetGraphicsContext($self.bitmap)
;~ 	_GDIPlus_GraphicsSetSmoothingMode($self.context, 2)

    $self.hDC = _WinAPI_GetDC($GUI)
    Local $hHBitmap = _WinAPI_CreateCompatibleBitmap($self.hDC, $self.w, $self.h)
    $self.buffer = _WinAPI_CreateCompatibleDC($self.hDC)
    Local $DC_obj = _WinAPI_SelectObject($self.buffer, $hHBitmap)
    $self.context = _GDIPlus_GraphicsCreateFromHDC($self.buffer)
    _GDIPlus_GraphicsSetSmoothingMode($self.context, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
    _GDIPlus_GraphicsSetPixelOffsetMode($self.context, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

	Return True
EndFunc


Func _Engine_Env($self, $env)

	$self.env = Enviroment($env, $self)

EndFunc

Func _Engine_PlayerInit($self, $data)

	$self.player = Player($data, $self)

EndFunc
