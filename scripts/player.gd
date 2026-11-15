extends CharacterBody2D

var HP = 100
var dead = false
var can_super_jump = false
const SPEED = 500
const JUMP_VELOCITY = -600.0
const SUPER_JUMP_VELOCITY = -1400.0
const G = preload("res://scripts/globals.gd")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var is_attacking = false
@onready var gun: Sprite2D = $Gun
var in_space = false
var hurt_time = 0.0

func take_damage(amount):
	if dead:
		return
	HP -= amount
	if HP <= 0:
		die()
		return
		
	hurt_time = 0.4
	animated_sprite.play("hurt")

func die():
	dead = true
	$Gun.visible = false
	velocity = Vector2.ZERO
	animated_sprite.play("death")

	await get_tree().create_timer(2.0).timeout
	G.last_level = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/lose.tscn")

func shoot():
	$Shot.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = gun.global_position
	var mouse_pos = get_global_mouse_position()
	bullet.direction = (mouse_pos - global_position).normalized()
	get_tree().root.add_child(bullet)
	
func _physics_process(delta):
	if dead:
		return


	if in_space:
		velocity.y += get_gravity().y * delta
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("jump")
		if global_position.y > 600:
			global_position.y = -300
			velocity = Vector2.ZERO
	elif not is_on_floor():
		var gravity = get_gravity()
		if can_super_jump and Input.is_action_pressed("jump") and velocity.y < 0:
			gravity *= 0.1
		velocity += gravity * delta

	if can_super_jump and global_position.y < -4000:
		get_tree().change_scene_to_file("res://scenes/galaxy.tscn")
		return


	if hurt_time > 0:
		hurt_time -= delta
		velocity.x = 0
	else:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			animated_sprite.play("jump")
			velocity.y = SUPER_JUMP_VELOCITY if can_super_jump else JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			if direction < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			if animated_sprite.animation != "jump":
				animated_sprite.play("walk")			
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if animated_sprite.animation != "jump":
				animated_sprite.play("idle")
				
		if is_on_floor() and animated_sprite.animation == "jump" and velocity.y >= 0:
			if direction:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("attack") and !is_attacking :
		is_attacking = true
		shoot()
	
	var to_mouse = (get_global_mouse_position() - global_position).normalized()
	gun.position = gun.position.lerp(to_mouse * 40, 5 * delta)
	gun.rotation = to_mouse.angle()
	if to_mouse.x < 0:
		gun.flip_v = true
	else:
		gun.flip_v = false
	
	move_and_slide() 
