extends Control

func _ready():
	$CanvasLayer/VBoxContainer/Yes.grab_focus()

func _on_yes_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _on_no_pressed():
	get_tree().quit()
