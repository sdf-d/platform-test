extends KinematicBody2D

var is_sleep = false

var anim_player

var coll_player

var movetimer_length = 50
var movetimer = 0

export(int) var hp = 10

func _ready():
	anim_player = get_node("AnimatedSprite/AnimationPlayer")
	coll_player = get_node("CollisionShape2D/AnimationPlayer")
	anim_player.play()
	coll_player.play()
	movedir = dir.rand()
	movement_loop()

func sleep():
	hp -= 1
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	if hp <= 0:
		is_sleep = true
		$AnimatedSprite.play("destroy")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Timer.start()
		get_parent().get_node("ScreenShake").screen_shake(1, 20, 150)

	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "Dog" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.sleep()

func _physics_process(delta):
	if is_sleep == false:
		movement_loop()
		if movetimer > 0:
			movetimer -= 1
		if movetimer == 0 || is_on_wall():
			movedir = dir.rand()
			movetimer = movetimer_length