extends Area2D

@onready var tilemap3: Node2D = get_node("../TileMap3")
@onready var tilemap4: Node2D = get_node("../TileMap4")
@onready var tilemap7: Node2D = get_node("../TileMap7")

func _ready():
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if not is_connected("body_exited", Callable(self, "_on_body_exited")):
		connect("body_exited", Callable(self, "_on_body_exited"))
	#connect("body_entered", self, "_on_body_entered")
	#connect("body_exited", self, "_on_body_exited")
	#pass

func _process(delta):
	if Input.is_action_just_pressed("x") and tilemap4.visible:
		load_previous_room()

func _on_body_entered(body: Node):
	if body.has_method("player") && RoomInfo.curr_y != 0:
		#print("Entered")
		toggle_tilemaps(true)

func _on_body_exited(body: Node):
	# Again, check if the body is the player
	if body.has_method("player") && RoomInfo.curr_y != 0:
		#print("Exited")
		toggle_tilemaps(false)

func toggle_tilemaps(entered: bool):
	if get_parent().is_in_group("Boss Room"):
		var enemies = get_parent().get_tree().get_nodes_in_group("Enemy")
		if len(enemies) == 0 and entered:
			# If the player has entered the area, make the first tilemap invisible and the second one visible
			tilemap3.visible = false
			tilemap4.visible = true
		else:
			# If the player has left the area, revert the visibility back
			tilemap3.visible = true
			tilemap4.visible = false
	else:	
		if entered:
			# If the player has entered the area, make the first tilemap invisible and the second one visible
			tilemap3.visible = false
			tilemap4.visible = true
		else:
			# If the player has left the area, revert the visibility back
			tilemap3.visible = true
			tilemap4.visible = false

func load_previous_room():
	'''
	 # Move the player up to the next room
	PlayerData.move_down()
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
		PlayerData.player_start_position = Vector2(player.position.x, -170)
	else:
		PlayerData.player_start_position = Vector2.ZERO
	
	# Change to the determined room scene
	get_tree().change_scene_to_file(scene_path)
	'''
	if get_parent().is_in_group("Boss Room"):
		var enemies = get_parent().get_tree().get_nodes_in_group("Enemy")
		if len(enemies) > 0:
			return
	var container = get_parent().get_parent()
	if RoomInfo.curr_y == 0:
		return
	PlayerData.player_start_position = Vector2(0,-180)
	PlayerData.player_start_direction = "down"
	container.load_room(RoomInfo.curr_x, RoomInfo.curr_y - 1)

#func load_previous_room():
	#PlayerData.previous_room()  # Adjust the PlayerData to the previous room state
	#var scene_path
	#if PlayerData.is_current_room_cleared():
		#scene_path = "res://Scenes/Rooms/room_without_enemies.tscn"  # Load without enemies if cleared
	#else:
		#scene_path = "res://Scenes/Rooms/room.tscn"  # Load with enemies if not cleared
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node_or_null("Player")
	#if player and player.has_method("player"):
		## Make sure to update the Y position for the previous room
		#PlayerData.player_start_position = Vector2(player.position.x, -170)
	#else:
		#PlayerData.player_start_position = Vector2.ZERO
	#
	## Change to the previous room based on whether it's cleared
	#get_tree().change_scene_to_file(scene_path)

#func reload_room(new_y_position: float = -170.0):
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node_or_null("Player")
	#if player and player.has_method("player"):
		#PlayerData.player_start_position = Vector2(player.position.x, new_y_position)
	#else:
		#PlayerData.player_start_position = Vector2.ZERO
	#get_tree().reload_current_scene()
