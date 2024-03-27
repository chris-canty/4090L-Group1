extends Control

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	get_parent().visible = false
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	$PanelContainer/VBoxContainer/Resume.grab_focus()
	get_parent().visible = true
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		
func _on_resume_pressed():
	resume()
	
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	$AnimationPlayer.seek(0, true) 
	
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	
func _process(delta):
	testEsc()

