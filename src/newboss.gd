extends KinematicBody2D

var movedir = Vector2(0, 0)

var hp = 20

var movetimer_length = 60
var movetimer = 0

var is_sleep = false

var speed = 50

var spritespin
var collspin

func _physics_process(delta):
	movement_loop()
	if is_sleep == false:
		spritespin.play()
		collspin.play()
		$AnimatedSprite.play("default")
		if movetimer > 0:
			movetimer -= 1
		if movetimer == 0 || is_on_wall():
			movedir = dir.rand()
			movetimer = movetimer_length


func _ready():
	spritespin = get_node("AnimatedSprite/AnimationPlayer") 
	collspin = get_node("CollisionShape2D/AnimationPlayer")
	movedir = dir.rand()

func movement_loop():
	var motion
	motion = movedir.normalized() * speed
	move_and_slide(motion, Vector2(0, 0))

func sleep():
	hp -= 1
	speed = 300
	movetimer_length = 10
	$AnimatedSprite/AnimationPlayer.set_speed_scale(3)
	$CollisionShape2D/AnimationPlayer.set_speed_scale(3)
	$Timer2.start()
	$Timer3.start()
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	is_sleep = true
	$AnimatedSprite.play("damaged")
	if hp <= 0:
		is_sleep = true
		speed = 140
		$AnimatedSprite.play("dead")
		$CollisionShape2D.call_deferred("set_disabled", true)
		movedir = Vector2(0, 1)
		$Timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_Timer2_timeout():
	if hp > 0:
		is_sleep = false

func _on_Timer3_timeout():
	speed = 50
	movetimer_length = 60
	$AnimatedSprite/AnimationPlayer.set_speed_scale(1)
	$CollisionShape2D/AnimationPlayer.set_speed_scale(1)