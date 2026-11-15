extends CharacterBody2D
var speed = 1000
var direction = Vector2.RIGHT
var pickup_distance = 100
var can_be_picked_up = false
var gone = false

func _ready():
	rotation = direction.angle()
	$ScreenNotifier.screen_exited.connect(_lost)


func _lost():
	if gone or not is_inside_tree() or get_tree().current_scene == null:
		return
	gone = true
	var G = preload("res://scripts/globals.gd")
	G.last_level = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/lose.tscn")

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())
		rotation = direction.angle()
		
	if !can_be_picked_up and !player_nearby():
		can_be_picked_up = true

	if can_be_picked_up and player_nearby():
		gone = true
		queue_free()
		get_tree().get_first_node_in_group("player").is_attacking = false

func _on_hitbox_body_entered(body):
	if body.is_in_group("zombie"):
		body.take_damage(25)

func player_nearby():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return false
	return global_position.distance_to(player.get_node("CollisionShape2D").global_position) < pickup_distance
