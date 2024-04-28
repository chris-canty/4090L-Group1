extends Area2D

signal player_entered

func _ready():
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	#if not is_connected("body_exited", Callable(self, "_on_body_exited")):
		#connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta):
	# Check if the "x" key is pressed while the player is inside the collision box
	if is_inside_area() and Input.is_action_just_pressed("x"):
		load_next_room()

func _on_body_entered(body):
	if body.has_method("player"):
		emit_signal("player_entered")

#func _on_body_exited(body):
	#if body.has_method("player"):
		#emit_signal("player_exited")

func is_inside_area():
	for body in get_overlapping_bodies():
		if body.has_method("player"):
			return true
	return false

func load_next_room():
	# Move the player up to the next room
	'''
	PlayerData.move_left()
	var scene_path
	# Check if the current room is cleared to decide the scene to load
	if PlayerData.is_current_room_cleared():
		scene_path = "res://Scenes/Rooms/room_without_enemies.tscn"
	else:
		scene_path = "res://Scenes/Rooms/room.tscn"
	
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node_or_null("Player")
	# Set the player's start position for the next room
	if player and player.has_method("player"):
		PlayerData.player_start_position = Vector2(-player.position.x, player.position.y)
	else:
		PlayerData.player_start_position = Vector2.ZERO
	
	# Change to the determined room scene
	get_tree().change_scene_to_file(scene_path)
	'''
	var container = get_parent().get_parent()
	if RoomInfo.curr_x == 0:
		return
	PlayerData.player_start_position = Vector2(220,-90)
	PlayerData.player_start_direction = "left"
	container.load_room(RoomInfo.curr_x - 1, RoomInfo.curr_y)
