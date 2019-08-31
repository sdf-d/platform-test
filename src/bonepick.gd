extends RigidBody2D

const GRAVITY = 50
const FLOOR = Vector2(0, -1)

var motion = Vector2()


func _physics_process(delta):
	
	motion.y += delta * GRAVITY
	
	motion.y += GRAVITY
	

func _ready():
	pass

func _on_bonepick_body_entered(body):
	if "Dog" in body.name:
		queue_free()