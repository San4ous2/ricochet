extends StaticBody2D


func _physics_process(_delta):
	var bodies = $Trigger.get_overlapping_bodies()
	var player_inside = false
	for body in bodies:
		if body.is_in_group("player"):
			player_inside = true
	if not player_inside:
		$Hint.visible = false
		return
	if get_tree().get_nodes_in_group("zombie").size() > 0:
		$Hint.text = "KILL ALL ZOMBIES FIRST!"
		$Hint.visible = true
		return
	$Hint.text = "HOLD SPACE TO JUMP HIGHER"
	$Hint.visible = true
	for body in bodies:
		if body.is_in_group("player"):
			body.can_super_jump = true
