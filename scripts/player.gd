extends CharacterBody2D

var HP = 100
var dead = false
var can_super_jump = false
const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var is_attacking = false
@onready var gun: Sprite2D = $Gun

func take_damage(amount):
	if dead:
		return
	HP -= amount
	print("player HP: ", HP)
	if HP <= 0:
		die()

func die():
	dead = true
	$Gun.visible = false
	velocity = Vector2.ZERO

	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = gun.global_position
	var mouse_pos = get_global_mouse_position()
	bullet.direction = (mouse_pos - global_position).normalized()
	get_tree().root.add_child(bullet)
	
func _physics_process(delta):
	if dead:
		return

	if not is_on_floor():
		var gravity = get_gravity()
		if can_super_jump and Input.is_action_pressed("jump") and velocity.y < 0:
			gravity *= 0.1
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("jump")
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack") and !is_attacking :
		is_attacking = true
		shoot()
	
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
	
	var to_mouse = (get_global_mouse_position() - global_position).normalized()
	gun.position = gun.position.lerp(to_mouse * 40, 5 * delta)
	gun.rotation = to_mouse.angle()
	if to_mouse.x < 0:
		gun.flip_v = true
	else:
		gun.flip_v = false
	
	move_and_slide() 
