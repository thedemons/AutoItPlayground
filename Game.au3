#include "_header.au3"

$Gui = GUICreate("AutoIt Play Ground", 100, 100)
GUISetState()

$Engine = EngineStart($Gui)
If $Engine = False Then __msgEngineFailed()

; map =====================================================================================================================================================
$strEnv = '{"mapid":0,"cBk":0xFF000000,"color":0x66005825,"w":10000,"h":10000,"gridsize":100,"gridw":5,"objs":'

; grond
$strEnv &= '{"obj1":{"name":"ground", "x" :0,"y":500, "cGlow":0xFF00FF00,"color":0xFF009900,"cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":1200, "y2":0, "x3":1200,"y3":40, "x4":0, "y4":40}}, "boxs":{"box1":{"x": 0, "y": 0, "w":1200, "h":40}}},'

; wall
$strEnv &= '"obj2":{"name":"wall", "x":500,"y":300, "cGlow":0xFFFF9900, "color":0x99FF9900, "cBk":0x33CC4400, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":300, "y2":0, "x3":300,"y3":200, "x4":0, "y4":200}}, "boxs":{"box1":{"x": 0, "y": 0, "w":300, "h":200}}},'

; down
$strEnv &= '"obj3":{"name":"down", "x":1160,"y":540, "cGlow":0xFF00FF00, "color":0xFF009900, "cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":40, "y2":0, "x3":40,"y3":300, "x4":0, "y4":300}}, "boxs":{"box1":{"x": 0, "y": 0, "w":40, "h":300}}},'

; ground down
$strEnv &= '"obj1":{"name":"grounddown", "x" :1160,"y":840, "cGlow":0xFF00FF00,"color":0xFF009900,"cBk":0x33FFFFFF, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":1200, "y2":0, "x3":1200,"y3":40, "x4":0, "y4":40}}, "boxs":{"box1":{"x": 0, "y": 0, "w":1200, "h":40}}},'

; wall down
$strEnv &= '"obj2":{"name":"walldown", "x":1600,"y":600, "cGlow":0xFF00c8ff, "color":0x9900c8ff, "cBk":0xFF001d26, "lineW":3,"nodes":'
$strEnv &= '{"node1":{"x1": 0, "y1": 0, "x2":200, "y2":80, "x3":300,"y3":200, "x4":100, "y4":120}}, "boxs":{"box1":{"x": 0, "y": 0, "w":0, "h":0}}}'

$strEnv &= '}}'
; ####-----------------------------------------------------------------------------------------------------------------------------------------------------

$Engine.enviroment = $strEnv

$Engine.playerinit = '{"name":"thedemons", "speed":10, "walk":1, "run":2, "gravity":1.2, "gravityspeed":0, "jump":20, "weight":20, "state":0, "cBk":0xCCFFFFFF, "color":0xFF56ffff, "cW":2,"x" : 0, "y" : 0, "w":50, "h":50", "weapon":0, "health":100}'

;~ $Engine.enemyinit = '{"enemies":{"enemy1":{{"name":"AI1", "speed":10, "walk":0.6, "run":2, "gravity":1.2, "gravityspeed":0, "jump":20, "weight":20, "state":0, "cBk":0xCCFFFFFF, "color":0xFF56ffff, "cW":2,"x" : 0, "y" : 0, "w":50, "h":50", "weapon":0, "health":100}}}}'


$Engine.camera.attachto($Engine.player)

While 1
	If GUIGetMsg() = -3 Then Exit

	$Engine.draw()

	If _IsPressed("41") Then $Engine.player.moveL(_IsPressed("A0")) ; shift for fast run
	If _IsPressed("44") Then $Engine.player.moveR(_IsPressed("A0"))
	If _IsPressed("20") Then $Engine.player.moveU()
WEnd
