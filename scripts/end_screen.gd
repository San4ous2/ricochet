extends Node2D

const G = preload("res://scripts/globals.gd")

@export_file("*.tscn") var retry_scene: String
@export var use_last_level = false

func _on_retry_pressed():
	var target: String = G.last_level if use_last_level else retry_scene
	if target.is_empty():
		target = "res://scenes/menu.tscn"
	get_tree().change_scene_to_file(target)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
