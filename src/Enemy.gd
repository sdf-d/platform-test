extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 400
const ACCELERATION = 50

const bonep = preload("res://bonepick.tscn")

var motion = Vector2()

var movedir = Vector2(0, 0)

export (int) var detect_radius

export (float) var fire_rate

export (PackedScene) var Bullet 

var direction = 1

var is_sleep = false

var target

var can_shoot = true

var vis_color = Color(.867, .91, .247, 0.1)

export(int) var speed = 30

export(int) var hp = 3

export(Vector2) var size = Vector2(1, 1)

var b = 0

func _ready():
	randomize()
	b = randi() % 10
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate

func sleep():
	hp -= 1
	speed = 100
	$Timer2.start()
	$Timer3.start()
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	is_sleep = true
	$AnimatedSprite.play("damaged")
	if hp <= 0:
		$Particles2D2.emitting = true
		is_sleep = true
		motion = Vector2(0,0)
		speed = 20
		$AnimatedSprite.play("sleep")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$LightOccluder2D.call_deferred("set_visible", false)
		$Timer.start()
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)

func _physics_process(delta):
	if is_sleep == false:
		update()
		motion.x = speed * direction

		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		motion.y += GRAVITY
	
		motion = move_and_slide(motion, FLOOR)

		if target:
			if can_shoot:
				shoot(target.position)

	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1

	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

	if speed == 100:
		$Particles2D.emitting = true

	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "Dog" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.sleep()

func shoot(pos):
		var b = Bullet.instance()
		var a = (pos - global_position).angle()
		b.start(global_position, a + rand_range(-0.05, 0.05))
		get_parent().add_child(b)
		can_shoot = false
		$ShootTimer.start()

#func _draw():
	#draw_circle(Vector2(), detect_radius, vis_color)

func _on_Timer2_timeout():
	if hp > 0:
		is_sleep = false

	if speed == 100:
		$AnimatedSprite.play("panic")

func _on_Timer3_timeout():
	speed = 30
	if speed == 30:
		$AnimatedSprite.play("default")

func _on_ShootTimer_timeout():
	can_shoot = true

func _on_Visibility_body_entered(body):
	pass

func _on_Visibility_body_exited(body):
	if body == target:
		target = null

func _on_Timer_timeout():
	for i in range(b):
		var bonepick = bonep.instance()
		get_parent().add_child(bonepick)
		bonepick.position = $Position2D.global_position
	$Particles2D2.emitting = false
	queue_free()