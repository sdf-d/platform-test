extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level1scene# = load("res://testarea.tscn")
var hpbarscene = load("res://hpbonebar.tscn")
var canvaspause_scene = load("res://canvaspause.tscn")
var canvaspause
var level
var gui
var hpbar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	spawnHPBar()
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func loadLevelFromScene(scenename):
	#print("loadLevelFromScene" , scenename)
	level1scene = load(scenename)
	level = level1scene.instance()
	add_child(level)
	
	canvaspause = canvaspause_scene.instance()
	canvaspause.get_node("Control2").visible = false  
	level.add_child(canvaspause)
	canvaspause.get_node("Control2").connect("go_to_title", get_node(".."), "_on_go_to_title")
	
	var dognode = level.get_node("Dog")
	dognode.connect("hp_changed", hpbar, "_on_Dog_hp_changed")
	dognode.init()
	return level

#func _on_go_to_title():
#	level.call_deferred("free")
	

func spawnHPBar():
	hpbar = hpbarscene.instance()
	#print(self.get_parent().get_child_count())
	add_child(hpbar)
	#print(get_node("Camera2D").get_child_count())
	#var barsprite = hpbar.get_child(0)
	#barsprite.position.x = 0
	#barsprite.position.y = -13
	#barsprite.z_index = 10
	#barsprite.visible = true
	#return hpbar