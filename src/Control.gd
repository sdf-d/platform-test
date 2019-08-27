extends Control

signal go_to_title

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state	

func _ready():
	pass

func _on_TextureButton1_pressed():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state	


func _on_TextureButton2_pressed():
	get_tree().quit()


func _on_TextureButton_pressed():
	get_tree().paused = false
	emit_signal("go_to_title")
	
	#get_tree().change_scene("TitleScreen.tscn")
