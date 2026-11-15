extends Node2D

const ZOMBIE = preload("res://scenes/zombie.tscn")
const SPAWN_EVERY = 5.0
const MAX_ZOMBIES = 8
var zombie_ct = 0
var timer = 2.0

func _physics_process(delta):
	print(zombie_ct)
	timer -= delta
	if timer > 0:
		return

	timer = SPAWN_EVERY
	
	if zombie_ct >= MAX_ZOMBIES:
		return

	var zombie = ZOMBIE.instantiate()
	var spread = Vector2(randf_range(-80, 80), 0)
	zombie.global_position = global_position + spread
	get_parent().add_child(zombie)
	zombie_ct+=1
	
