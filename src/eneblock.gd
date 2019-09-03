extends KinematicBody2D

var movedir = Vector2(0, 0)

var hp = 3

var movetimer_length = 60
var movetimer = 0

var is_sleep = false

var speed = 50

var hit_pos

var spritespin
var collspin
var lightspin

var b = 0

const bonep = preload("res://bonepick.tscn")

export (int) var detect_radius

export (float) var fire_rate

export (PackedScene) var Bullet

var target

var can_shoot = true

var vis_color = Color(.867, .91, .247, 0.1)

var laser_color = Color(.867, .91, .247, 0.1)

func _physics_process(delta):
	movement_loop()
	randomize()
	b = randi() % 10
	if is_sleep == false:
		update()
		spritespin.play()
		collspin.play()
		#lightspin.play()
		$AnimatedSprite.play("default")
		if movetimer > 0:
			movetimer -= 1
		if movetimer == 0 || is_on_wall():
			movedir = dir.rand()
			movetimer = movetimer_length
		if target:
			if can_shoot:
				shoot(target.position)

func _ready():
	spritespin = get_node("AnimatedSprite/AnimationPlayer") 
	collspin = get_node("CollisionShape2D/AnimationPlayer")
	lightspin = get_node("LightOccluder2D/AnimationPlayer")
	movedir = dir.rand()
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate

func movement_loop():
	var motion
	motion = movedir.normalized() * speed
	move_and_slide(motion, Vector2(0, 0))

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start($Position2D.global_position + Vector2(-16.0,16.0), a + rand_range(-0.01, 0.01))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

#func _draw():
	#draw_circle(Vector2(), detect_radius, vis_color)

func sleep():
	hp -= 1
	speed = 300
	movetimer_length = 10
	$Timer2.start()
	$Timer3.start()
	$AnimatedSprite/AnimationPlayer.set_speed_scale(3)
	$CollisionShape2D/AnimationPlayer.set_speed_scale(3)
	$LightOccluder2D/AnimationPlayer.set_speed_scale(3)
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	is_sleep = true
	$AnimatedSprite.play("damaged")
	if hp <= 0:
		$Particles2D2.emitting = true
		is_sleep = true
		speed = 70
		$CollisionShape2D.call_deferred("set_disabled", true)
		$LightOccluder2D.call_deferred("set_visible", false)
		movedir = Vector2(0, 1)
		$AnimatedSprite.play("dead")
		$Timer.start()

func _on_Timer_timeout():
	for i in range(b):
		var bonepick = bonep.instance()
		get_parent().add_child(bonepick)
		bonepick.position = $Position2D.global_position
	$Particles2D2.emitting = false
	queue_free()

func _on_Timer2_timeout():
	if hp > 0:
		is_sleep = false

func _on_Timer3_timeout():
	speed = 50
	movetimer_length = 60
	$AnimatedSprite/AnimationPlayer.set_speed_scale(1)
	$CollisionShape2D/AnimationPlayer.set_speed_scale(1)
	$LightOccluder2D/AnimationPlayer.set_speed_scale(1)

func _on_Visibility_body_entered(body):
	if target:
		return
	target = body

func _on_Visibility_body_exited(body):
	can_shoot = false
	if body == target:
		target = null

func _on_ShootTimer_timeout():
	can_shoot = true
