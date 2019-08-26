extends KinematicBody2D

const GRAVITY = 50
const FLOOR = Vector2(0, -1)

var motion = Vector2()

func _physics_process(delta):
	motion.y += delta * GRAVITY
	
	motion = move_and_slide(motion, FLOOR)
	
	motion.y += GRAVITY

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
