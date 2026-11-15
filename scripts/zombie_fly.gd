extends CharacterBody2D

const SPEED = 80
const DAMAGE = 34
const ATTACK_DISTANCE = 200
const ATTACK_TIME = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var HP = 100
var can_attack = true
var hurt_time = 0.0
var bob_phase = randf() * TAU

func _ready():
	add_to_group("zombie")

func take_damage(amount):
	$HurtSound.play()
	HP -= amount
	if HP <= 0:
		animated_sprite.play("flying_death")
		await animated_sprite.animation_finished
		queue_free()
	else:
		hurt_time = 0.3
		animated_sprite.play("flying_hurt")

func _physics_process(delta):
	if HP <= 0:
		return

	if hurt_time > 0:
		hurt_time -= delta
		return

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	if !can_attack:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance < ATTACK_DISTANCE:
		can_attack = false
		animated_sprite.play("flying_attack")
		player.take_damage(DAMAGE)
		await get_tree().create_timer(ATTACK_TIME).timeout
		can_attack = true
		return

	bob_phase += delta * 3.0
	var direction_to_player = (player.global_position - global_position).normalized()
	velocity = direction_to_player * SPEED
	velocity.y += sin(bob_phase) * 60.0
	move_and_slide()

	animated_sprite.flip_h = velocity.x < 0
	animated_sprite.play("flying_walk")
