extends Node2D

var coins = 0
var elapsed_time = 0.0
var total_coins = 10
var level_completed = false
var manually_paused = false
var game_over = false

@onready var coin_label = $UI/CoinLabel
@onready var timer_label = $UI/TimerLabel
@onready var game_timer = $GameTimer
@onready var completion_label = $UI/CompletionLabel


func _ready():
	update_coin_label()
	timer_label.text = "TIME: 0.0"
	completion_label.visible = false
	game_timer.start()


func _process(delta):
	if not level_completed and not manually_paused:
		elapsed_time += delta
		timer_label.text = "TIME: " + str(round(elapsed_time * 10) / 10.0)


func update_coin_label():
	coin_label.text = "COINS: " + str(coins)


func check_completion():
	if coins >= total_coins:
		complete_level()


func complete_level():
	game_over = true
	level_completed = true
	game_timer.stop()
	completion_label.text = "LEVEL COMPLETED!\nTIME: " + str(round(elapsed_time * 10) / 10.0) + " seconds\nCOINS: " + str(coins) + "/" + str(total_coins)
	completion_label.visible = true
	$UI/PauseOverlay.visible = true
	$UI/RestartButton.visible = true
	$UI/BackToLevelsButton.visible = true
	$UI/PauseButton.visible = false
	$UI/ResumeButton.visible = false
	$UI/CoinLabel.visible = false
	$UI/TimerLabel.visible = false
	get_tree().paused = true
	save_high_score()
	
func save_high_score():
	var file_path = "user://highscores.save"
	var scores = []

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		scores = file.get_var()
		file.close()

	scores.append(elapsed_time)

	scores.sort()

	if scores.size() > 5:
		scores = scores.slice(0, 5)

	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(scores)
	file.close()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func show_death_screen():
	game_over = true
	game_timer.stop()
	$UI/PauseOverlay.visible = true
	$UI/RestartButton.visible = true
	$UI/BackToLevelsButton.visible = true
	$UI/PauseButton.visible = false
	$UI/ResumeButton.visible = false
	$UI/CoinLabel.visible = false
	$UI/TimerLabel.visible = false
	get_tree().paused = true


func _on_back_to_levels_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_pause_button_pressed() -> void:
	manually_paused = true
	$UI/PauseOverlay.visible = true
	$UI/PauseButton.visible = false
	$UI/ResumeButton.visible = true
	$UI/RestartButton.visible = true
	$UI/BackToLevelsButton.visible = true
	get_tree().paused = true


func _on_resume_button_pressed() -> void:
	manually_paused = false
	get_tree().paused = false
	$UI/PauseOverlay.visible = false
	$UI/PauseButton.visible = true
	$UI/ResumeButton.visible = false
	$UI/RestartButton.visible = false
	$UI/BackToLevelsButton.visible = false
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if game_over:
			return

		if manually_paused:
			_on_resume_button_pressed()
		else:
			_on_pause_button_pressed()
