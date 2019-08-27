extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#print("guispawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Dog_hp_changed(newhp):
	#print("AHA")
	#print(newhp)
	$Sprite.get_material().set_shader_param("hp",newhp)