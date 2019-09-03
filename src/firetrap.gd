extends Area2D

var fire
enum {HOT, NOT_HOT}

func _ready():
	fire = HOT
	trap()

func trap():
	if fire == HOT:
		$Timer.start()

func _on_Timer_timeout():
	fire = NOT_HOT
	$Particles2D.emitting = false
	$CollisionShape2D.disabled = true
	$Timer2.start()

func _on_Timer2_timeout():
	fire = HOT
	$Particles2D.emitting = true
	$CollisionShape2D.disabled = false
	trap()