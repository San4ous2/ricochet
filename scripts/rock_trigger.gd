extends StaticBody2D

func _on_trigger_body_entered(body):
	if body.is_in_group("player"):
		body.can_super_jump = true
		$Hint.visible = true
