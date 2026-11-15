extends TextureProgressBar

func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		value = player.HP
