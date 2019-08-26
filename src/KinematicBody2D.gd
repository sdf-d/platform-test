extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 600
var ACCELERATION = 15
var MAX_SPEED = 100
const JUMP_HEIGHT = -230
const MIN_JUMP = -100
const WALL_SLIDE = 200

const WALLJUMP_KNOCKBACK = 200
const hit_knockbackb = 250
const hit_knockbacku = 150

const BARK = preload("res://bark.tscn")

var hp = 5

var knockdir = Vector2(0, 0)

var is_invincible : bool = false

var is_sleep = false

var anim_player

var is_barking = false

var ray_cast_right
var ray_cast_left

var jump_count = 0
const MAX_JUMP_COUNT = 2

var motion = Vector2()

var hpbar
var Hpbonebar = preload("res://Hpbonebar.tscn")

signal dog_spawned
signal hp_changed(new_hp)

func _physics_process(delta):
	
	motion.y += delta * GRAVITY
	var friction = false

	if is_sleep == false:

		if Input.is_action_pressed("left"):
			if MAX_SPEED == 200 && is_on_floor():
				$Particles2D.emitting = true
				$dogsprite.play("sprint")
				$dogsprite.get_material().set_shader_param("run_state",-1)
			else:
				$dogsprite.get_material().set_shader_param("run_state",0)
				
			motion.x = -MAX_SPEED if motion.x-ACCELERATION <= -MAX_SPEED else motion.x-ACCELERATION #clamp(motion.x-ACCELERATION, -MAX_SPEED, MAX_SPEED)
			$ray_right.position.x *= 1
			get_node("dogsprite").set_flip_h(false)
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		elif Input.is_action_pressed("right"):
			if MAX_SPEED == 200 && is_on_floor():
				$Particles2D.emitting = true
				$dogsprite.play("sprint")
				$dogsprite.get_material().set_shader_param("run_state",1)
			else:
				$dogsprite.get_material().set_shader_param("run_state",0)
				
			#motion.x +=  ACCELERATION
			motion.x = MAX_SPEED if motion.x+ACCELERATION >= MAX_SPEED else motion.x+ACCELERATION #clamp(motion.x+ACCELERATION, -MAX_SPEED, MAX_SPEED)
			$ray_right.position.x *= -1
			get_node("dogsprite").set_flip_h(true)
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		else:
			friction = true
			motion.x = lerp(motion.x, 0, 0.2)
			$dogsprite.get_material().set_shader_param("run_state",0)

		motion = move_and_slide(motion, FLOOR)
		if is_on_floor():
			jump_count = 0
           
		if ray_cast_right.is_colliding():
			jump_count = 1
			
		elif ray_cast_left.is_colliding():
			jump_count = 1

		if Input.is_action_pressed("sprint"):
			MAX_SPEED = 200
		else:
			MAX_SPEED = 100

			if get_slide_count() > 0:
				for i in range(get_slide_count()):
					if "Enemy" in get_slide_collision(i).collider.name:
						sleep()

func sleep():
	hp -= 1
	emit_signal("hp_changed",hp)
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	motion.x = motion.x-hit_knockbackb
	motion.y = motion.y-hit_knockbacku
	is_invincible = true
	$Timer2.start()
	if hp <= 0:
		is_sleep = true
		motion = Vector2(0, 0)
		$dogsprite.play("sleep")
		$CollisionShape2D.disabled = true
		$Timer.start()

func _ready():
	set_process_input(true)
	anim_player = get_node("dogsprite/spin")
	ray_cast_right = get_node("ray_right")
	ray_cast_left = get_node ("ray_left")
	emit_signal("dog_spawned")
	emit_signal("hp_changed",hp)
	spawnHPBar()

func spawnHPBar():
	hpbar = Hpbonebar.instance()
	#print(self.get_parent().get_child_count())
	get_node("Camera2D").add_child(hpbar)
	#print(get_node("Camera2D").get_child_count())
	hpbar.position.x = 0
	hpbar.position.y = -13
	hpbar.z_index = 10
	hpbar.visible = true


func _input(event):
	if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("up"):
		motion.y = JUMP_HEIGHT
		anim_player.play()
		jump_count += 1
		if !is_on_floor():
			if ray_cast_left.is_colliding():
				motion.x = motion.x+WALLJUMP_KNOCKBACK
				$ray_right.position.x *= 1
				get_node("dogsprite").set_flip_h(true)
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
			elif ray_cast_right.is_colliding():
				motion.x = motion.x-WALLJUMP_KNOCKBACK
				$ray_right.position.x *= -1
				get_node("dogsprite").set_flip_h(false)
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	
	
	elif event.is_action_released("up"):
		motion.y = clamp(motion.y, MIN_JUMP, motion.y)

	if Input.is_action_just_pressed("shoot") && is_barking == false:
		is_barking = true
		$dogsprite.play("attack")
		var bark = BARK.instance()
		if sign($Position2D.position.x) == 1:
			bark.set_bark_direction(1)
		else:
			bark.set_bark_direction(-1)
		get_parent().add_child(bark)
		bark.position = $Position2D.global_position

func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")

func _on_Timer2_timeout():
	is_invincible = false

func _on_dogsprite_animation_finished():
	is_barking = false
	$dogsprite.play("default")