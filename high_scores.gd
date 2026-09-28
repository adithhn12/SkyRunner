extends Control

@onready var score_list = $ScoreList


func _ready():
	var file_path = "user://highscores.save"

	if not FileAccess.file_exists(file_path):
		var label = Label.new()
		label.text = "NO HIGH SCORES YET"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 24)
		score_list.add_child(label)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var scores = file.get_var()
	file.close()

	for i in range(scores.size()):
		create_score_row(i + 1, scores[i])


func create_score_row(rank: int, time: float):
	var row = PanelContainer.new()

	row.custom_minimum_size = Vector2(400, 60)

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.03, 0.05, 0.07, 0.85)
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = Color(0.45, 0.55, 0.35, 0.8)
	panel_style.corner_radius_top_left = 10
	panel_style.corner_radius_top_right = 10
	panel_style.corner_radius_bottom_left = 10
	panel_style.corner_radius_bottom_right = 10

	row.add_theme_stylebox_override("panel", panel_style)

	var label = Label.new()

	label.text = str(rank) + "     " + str(round(time * 10) / 10.0) + " seconds"

	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	label.add_theme_font_size_override("font_size", 24)

	if rank == 1:
		label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.25))
	else:
		label.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))

	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	label.add_theme_constant_override("outline_size", 6)

	row.add_child(label)
	score_list.add_child(row)


func _on_reset_button_pressed() -> void:
	var file_path = "user://highscores.save"

	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)

	get_tree().reload_current_scene()
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
