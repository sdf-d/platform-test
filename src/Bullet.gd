extends Area2D

var speed = 70
var velocity = Vector2()

const hdust = preload("res://hitdust.tscn")
var dust = hdust.instance()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta


func _on_Bullet_body_entered(body):
	if !"eneblock" in body.name:
		get_parent().add_child(dust)
		dust.position = $Position2D.global_position
		dust.emitting = true
		if "Dog" in body.name:
			body.sleep()
		queue_free()

func _on_Timer_timeout():
	dust.emitting = false