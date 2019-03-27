#include "_header.au3"

$Gui = GUICreate("AutoIt Play Ground", 100, 100)
GUISetState()

$Engine = EngineStart($Gui)
If $Engine = False Then __msgEngineFailed()

; map =====================================================================================================================================================
$strEnv = '{"mapid":0,"cBk":0xFF000000,"color":0x66005825,"w":10000,"h":10000,"gridsize":100,"gridw":5,"objs":'

; grond
$strEnv &= '{"obj1":{"name":"ground", "x" :0,"y":500, "w":1200, "h":40, "cGlow":0xFF00FF00,"color":0xFF009900,"cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":1200, "y2":0, "x3":1200,"y3":40, "x4":0, "y4":40}}},'

; wall
$strEnv &= '"obj2":{"name":"wall", "x":500,"y":300,"w":300, "h":200, "cGlow":0xFFFF9900, "color":0x99FF9900, "cBk":0x33CC4400, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":300, "y2":0, "x3":300,"y3":200, "x4":0, "y4":200}}},'

; downs
$strEnv &= '"obj3":{"name":"down", "x":1200,"y":500, "w":400, "h":380, "cGlow":0xFF00FF00, "color":0xFF009900, "cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":400, "y2":340, "x3":400,"y3":380, "x4":0, "y4":40}}},'

; ground down
$strEnv &= '"obj1":{"name":"grounddown", "x" :1600,"y":840, "w":1200, "h":40, "cGlow":0xFF00FF00,"color":0xFF009900,"cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":1200, "y2":0, "x3":1200,"y3":40, "x4":0, "y4":40}}},'

; wall down
$strEnv &= '"obj2":{"name":"walldown", "x":1900,"y":380, "w":1150, "h":400, "cGlow":0xFF00c8ff, "color":0xd9900c8ff, "cBk":0xFF001d26, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1":0,"y1":0,"x2":80,"y2":16,"x3":170,"y3":44,"x4":265,"y4":83,"x5":370,"y5":139,"x6":476,"y6":179,"x7":588,"y7":202,"x8":727,"y8":218,"x9":848,"y9":207,"x10":970,"y10":183,"x11":1055,"y11":151,"x12":1138,"y12":80,"x13":1179,"y13":48,"x14":1174,"y14":418,"x15":1134,"y15":423,"x16":1130,"y16":141,"x17":1015,"y17":219,"x18":854,"y18":255,"x19":668,"y19":253,"x20":507,"y20":234,"x21":328,"y21":163,"x22":182,"y22":92,"x23":43,"y23":44,"x24":38,"y24":398,"x25":-4,"y25":398}}}'

$strEnv &= '}}'
; ####-----------------------------------------------------------------------------------------------------------------------------------------------------

$Engine.enviroment = $strEnv

$Engine.playerinit = '{"name":"thedemons", "speed":10, "walk":1, "run":2, "gravity":1.2, "gravityspeed":0, "jump":20, "weight":20, "state":0, "cBk":0xCCFFFFFF, "color":0xFF56ffff, "cW":2,"x" : 0, "y" : 0, "w":50, "h":50", "weapon":0, "health":100}'

;~ $Engine.enemyinit = '{"enemies":{"enemy1":{{"name":"AI1", "speed":10, "walk":0.6, "run"s:2, "gravity":1.2, "gravityspeed":0, "jump":20, "weight":20, "state":0, "cBk":0xCCFFFFFF, "color":0xFF56ffff, "cW":2,"x" : 0, "y" : 0, "w":50, "h":50", "weapon":0, "health":100}}}}'

$Engine.camera.attachto($Engine.player)
$Engine.camera.z = 1

Local $rgn[5][2] = [[10,10], [500, 20], [700,320], [40, 400], [200, 250]]
Global $plg = _WinAPI_CreatePolygonRgn($rgn, 0, 4)
Global $testbrush2 = _WinAPI_CreateSolidBrush(0xFFFFFF)
While 1
	If GUIGetMsg() = -3 Then Exit
	$cur = GUIGetCursorInfo($Gui)
;~ 	$Engine.player.x = ($Engine.camera.x + $cur[0]) / $Engine.camera.z - 25
;~ 	$Engine.player.y = ($Engine.camera.y + $cur[1]) / $Engine.camera.z - 25
	_Engine_Draw($Engine)
;~ 	Sleep(50)

	If _IsPressed("41") Then $Engine.player.moveL(_IsPressed("A0")) ; shift for fast run
	If _IsPressed("44") Then $Engine.player.moveR(_IsPressed("A0"))
	If _IsPressed("53") Then $Engine.player.accelY += 1
	If _IsPressed("57") Then $Engine.player.accelY -= 1
	If _IsPressed("20") Then $Engine.player.moveU()

	If _IsPressed("56") And $Engine.camera.z > 0.2 Then
		$Engine.camera.move(0,0,-0.05)
	ElseIf _IsPressed("56") = False And $Engine.camera.z < 1 Then

		$Engine.camera.move(0,0,0.05)
	EndIf
WEnd
