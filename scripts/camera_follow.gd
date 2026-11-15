extends Camera2D

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position.x = player.global_position.x

	global_position.y = lerp(global_position.y, player.global_position.y - 200, 3 * delta)
