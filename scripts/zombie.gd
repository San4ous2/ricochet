extends CharacterBody2D

const SPEED = 100
const DAMAGE = 34
const ATTACK_DISTANCE = 200
const ATTACK_TIME = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var HP = 100
var can_attack = true
var hurt_time = 0.0

func _ready():
	add_to_group("zombie")

func take_damage(amount):
	$HurtSound.play()
	HP -= amount
	print("-", amount, " HP")
	if HP <= 0:
		animated_sprite.play("death")
		await animated_sprite.animation_finished
		queue_free()
	else:
		hurt_time = 0.3
		animated_sprite.play("hurt")

func _physics_process(delta):
	if HP <= 0:
		return

	if hurt_time > 0:
		hurt_time -= delta
		return

	var player = get_tree().get_first_node_in_group("player")

	if !can_attack:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance < ATTACK_DISTANCE:
		can_attack = false
		animated_sprite.play("punch")
		player.take_damage(DAMAGE)
		await get_tree().create_timer(ATTACK_TIME).timeout
		can_attack = true
		return

	var direction_to_player = (player.global_position - global_position).normalized()

	velocity.x = direction_to_player.x * SPEED
	move_and_slide()

	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
	animated_sprite.play("walk")
