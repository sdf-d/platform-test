extends Area2D

const SPEED = 300
var motion = Vector2()
var direction = 1

func _ready():
	pass 

func set_bark_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.set_flip_h(true)

func _physics_process(delta):
	motion.x = SPEED * delta * direction
	translate(motion)
	$AnimatedSprite.play("default")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bark_body_entered(body):
	if body.name != ("Dog"):
		if "dest" in body.name:
			body.sleep()
		if "Enemy" in body.name:
			body.sleep()
		if "eneblock" in body.name:
			body.sleep()
		if "newboss" in body.name:
			body.sleep()
		queue_free()