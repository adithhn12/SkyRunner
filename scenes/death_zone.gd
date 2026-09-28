extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var level = get_tree().current_scene
		level.show_death_screen()
