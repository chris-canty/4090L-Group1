extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$select.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/game_container.tscn")


func _on_player_options_button_pressed():
	$select.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/how_to_play.tscn")


func _on_quit_button_pressed():
	$select.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
