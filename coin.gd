extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var level = get_tree().current_scene
		level.coins += 1
		level.update_coin_label()
		level.check_completion()
		queue_free()
