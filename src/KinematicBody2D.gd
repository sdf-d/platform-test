extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const GRAVITY = 600
var ACCELERATION = 12
var MAX_SPEED = 100
const JUMP_HEIGHT = -230
const MIN_JUMP = -100
const WALL_SLIDE = 200
const MAX_HP = 20.0

const WALLJUMP_KNOCKBACK = 170
const hit_knockbackb = 250
const hit_knockbacku = 150

const BARK = preload("res://bark.tscn")

var hp = 20

var knockdir = Vector2(0, 0)

var is_invincible : bool = false

var is_sleep = false

var anim_player

var is_barking = false

var ray_cast_right
var ray_cast_left
var slope1
var slope2
var onslopeup
var onslopedown

var jump_count = 0
const MAX_JUMP_COUNT = 2

var motion = Vector2()

var hpbar
var hpbonebar = preload("res://hpbonebar.tscn")

signal dog_spawned
signal hp_changed(new_hp)

func _physics_process(delta):
	
	#search_slope()
	
	motion.y += delta * GRAVITY
	var friction = false

	if is_sleep == false:

		if Input.is_action_pressed("left"):
			$dogsprite.play("walk")
			if MAX_SPEED == 170 && is_on_floor():
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
			$dogsprite.play("walk")
			if MAX_SPEED == 170 && is_on_floor():
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
			MAX_SPEED = 170
		else:
			MAX_SPEED = 100

			if get_slide_count() > 0:
				var collision = get_slide_collision(0)
				var normal = collision.normal
				var angleDelta 
				if abs(normal.normalized().x) > 0.7:
					 angleDelta = normal.angle() - (rotation - PI * .5)
				else:
					angleDelta = -rotation
				rotation = angleDelta + rotation
				for i in range(get_slide_count()):
					if "Enemy" && "firetrap" in get_slide_collision(i).collider.name:
						sleep()
					elif "bonepick" in get_slide_collision(i).collider.name:
						$Particles2D.emitting = true
						hp += 1
						emit_signal("hp_changed",hp / MAX_HP)

func sleep():
	hp -= 1
	emit_signal("hp_changed",hp / MAX_HP)
	get_parent().get_node("ScreenShake").screen_shake(0.3, 3, 50)
	$dogsprite.play("damaged")
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
	ray_cast_left = get_node("ray_left")
	slope1 = get_node("slope1")
	slope2 = get_node("slope2")
	emit_signal("dog_spawned")
	#print("dogspawn")
	
	#spawnHPBar()


#func search_slope():
	if slope1.is_colliding() == true && slope2.is_colliding() == false:
		onslopedown = true
		print("going down a slope")
		$dogsprite.rotation = 45
	elif slope2.is_colliding() == true && slope1.is_colliding() == false:
		onslopeup = true
		print("going up a slope")
		$dogsprite.rotation = -45
	else:
		$dogsprite.rotation = 0
		onslopedown = false
		onslopeup = false

func init():
	emit_signal("hp_changed", hp / MAX_HP)

func spawnHPBar():
	hpbar = hpbonebar.instance()

	add_child(hpbar)

	var barsprite = hpbar.get_child(0)
	barsprite.position.x = 0
	barsprite.position.y = -13
	barsprite.z_index = 10
	barsprite.visible = true


func _input(event):
	if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("up"):
		motion.y = JUMP_HEIGHT
		anim_player.play()
		jump_count += 1
		if !is_on_floor():
			jump_count = 2
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
	
	if Input.is_action_pressed("down"):
		$dogsprite.play("crouchidle")

func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")

func _on_Timer2_timeout():
	is_invincible = false

func _on_dogsprite_animation_finished():
	is_barking = false
	$dogsprite.play("default")