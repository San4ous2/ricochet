extends Area2D

@export_file("*.tscn") var next_scene: String

func _physics_process(_delta):
	var player_inside = false
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			player_inside = true
	if not player_inside:
		return
	if get_tree().get_nodes_in_group("zombie").size() > 0:
		return
	get_tree().change_scene_to_file(next_scene)
