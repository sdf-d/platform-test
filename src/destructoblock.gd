extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 600
const ACCELERATION = 0

var motion = Vector2()

var direction = 1

var is_sleep = false

export(int) var speed = 0

export(int) var hp = 1

export(Vector2) var size = Vector2(1, 1)

func sleep():
	hp -= 1
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	if hp <= 0:
		is_sleep = true
		motion = Vector2(0,0)
		$AnimatedSprite.play("destroy")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$LightOccluder2D.call_deferred("set_visible", false)
		$Timer.start()
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)

func _physics_process(delta):
	if is_sleep == false:
		motion.x = speed * direction

		motion.y += GRAVITY
	
		motion = move_and_slide(motion, FLOOR)


func _on_Timer_timeout():
	queue_free()
