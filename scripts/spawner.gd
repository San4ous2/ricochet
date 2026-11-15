extends Node2D

const ZOMBIE = preload("res://scenes/zombie.tscn")
const ZOMBIE_FLY = preload("res://scenes/zombie_fly.tscn")
const SPAWN_EVERY = 5.0
const MAX_ZOMBIES = 8

@export var far_spawn = true

@export var total_limit = 8

@export var flying = false

var timer = 2.0
var spawned = 0

func finished():
	return total_limit > 0 and spawned >= total_limit

func _physics_process(delta):
	timer -= delta
	if timer > 0:
		return

	timer = SPAWN_EVERY

	if finished():
		return

	if get_tree().get_nodes_in_group("zombie").size() >= MAX_ZOMBIES:
		return

	var zombie
	if flying:
		zombie = ZOMBIE_FLY.instantiate()
	else:
		zombie = ZOMBIE.instantiate()
	if far_spawn and randi_range(0, 1) == 1:
		zombie.global_position = global_position + Vector2(-2200, 0)
	else:
		zombie.global_position = global_position + Vector2(randf_range(-100, 100), 0)
	get_parent().add_child(zombie)
	spawned += 1
