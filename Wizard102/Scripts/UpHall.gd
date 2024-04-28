extends Area2D

@onready var tilemap: Node2D = get_node("../TileMap")
@onready var tilemap2: Node2D = get_node("../TileMap2")

func _ready():
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if not is_connected("body_exited", Callable(self, "_on_body_exited")):
		connect("body_exited", Callable(self, "_on_body_exited"))
	#pass

func _process(delta):
	if Input.is_action_just_pressed("x") and tilemap2.visible:
		load_next_room()

func _on_body_entered(body: Node):
	if body.has_method("player") && (RoomInfo.curr_y != 4 || RoomInfo.curr_x == 2):
		#print("Entered")
		toggle_tilemaps(true)

func _on_body_exited(body: Node):
	# Again, check if the body is the player
	if body.has_method("player") && RoomInfo.curr_y != 4:
		#print("Exited")
		toggle_tilemaps(false)

func toggle_tilemaps(entered: bool):
	if get_parent().is_in_group("Boss Room"):
		var enemies = get_parent().get_tree().get_nodes_in_group("Enemy")
		if len(enemies) == 0 and entered:
			# If the player has entered the area, make the first tilemap invisible and the second one visible
			tilemap.visible = false
			tilemap2.visible = true
		else:
			# If the player has left the area, revert the visibility back
			tilemap.visible = true
			tilemap2.visible = false
	else:
		if entered:
			# If the player has entered the area, make the first tilemap invisible and the second one visible
			tilemap.visible = false
			tilemap2.visible = true
		else:
			# If the player has left the area, revert the visibility back
			tilemap.visible = true
			tilemap2.visible = false

func load_next_room():
	'''
	# Move the player up to the next room
	PlayerData.move_up()
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
		PlayerData.player_start_position = Vector2(player.position.x, -17)
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
	if RoomInfo.curr_y == 4 and not RoomInfo.curr_x == 2:
		return
	PlayerData.player_start_position = Vector2(0,0)
	container.load_room(RoomInfo.curr_x, RoomInfo.curr_y + 1)


#func load_next_room():
	#PlayerData.next_room()
	#var scene_path
	#if PlayerData.is_current_room_cleared():
		#scene_path = "res://Scenes/Rooms/room_without_enemies.tscn"
	#else:
		#scene_path = "res://Scenes/Rooms/room.tscn"
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node_or_null("Player")
	#if player and player.has_method("player"):
		#PlayerData.player_start_position = Vector2(player.position.x, -17)
	#else:
		#PlayerData.player_start_position = Vector2.ZERO
#
	## Change to the next room based on whether it's cleared
	#get_tree().change_scene_to_file(scene_path)
