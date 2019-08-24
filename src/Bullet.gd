extends Area2D

var speed = 200
var velocity = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if !"eneblock" in body.name:
		if "Dog" in body.name:
			body.sleep()
		queue_free()