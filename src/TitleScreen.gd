extends Node

signal changeToGameLevel(level)

func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	if(get_parent()):
		init()
	
func init():
	self.connect("changeToGameLevel",get_node(".."), "_on_TitleScreen_changeToGameLevel")
	#$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.connect("pressed", self, "_on_TextureButton_pressed")

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.grab_focus()

func _on_TextureButton_pressed():
	#print("buttoooon1")
	emit_signal("changeToGameLevel","testarea.tscn")
	#get_tree().change_scene("Main_in_game.tscn")
	#get_tree().change_scene("testarea.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()

func _on_TextureButton3_pressed():
	#print("buttoooon2")
	emit_signal("changeToGameLevel","testblock.tscn")
	#get_tree().change_scene("testblock.tscn")
