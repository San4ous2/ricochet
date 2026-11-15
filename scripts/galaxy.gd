extends Node2D

func _physics_process(_delta):
	if $ZombieSpawn.finished() and get_tree().get_nodes_in_group("zombie").is_empty():
		get_tree().change_scene_to_file("res://scenes/win.tscn")
