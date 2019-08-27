extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maingamescene  = load("Main_in_game.tscn")
var titlescene = load("res://TitleScreen_nao.tscn")
var titlescreen
var maingame
var _level
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TitleScreen_changeToGameLevel(level):
	maingame = maingamescene.instance()
	add_child(maingame)
	_level = maingame.loadLevelFromScene(level)
	
	get_node("TitleScreen").call_deferred("free")
	
func _on_go_to_title():
	maingame.free()
	titlescreen = titlescene.instance()
	add_child(titlescreen)
	titlescreen.init()