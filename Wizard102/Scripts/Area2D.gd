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
	if body.has_method("player"):
		#print("Entered")
		toggle_tilemaps(true)

func _on_body_exited(body: Node):
	# Again, check if the body is the player
	if body.has_method("player"):
		#print("Exited")
		toggle_tilemaps(false)

func toggle_tilemaps(entered: bool):
	if entered:
		# If the player has entered the area, make the first tilemap invisible and the second one visible
		tilemap.visible = false
		tilemap2.visible = true
	else:
		# If the player has left the area, revert the visibility back
		tilemap.visible = true
		tilemap2.visible = false

#func load_next_room():
	#PlayerData.next_room()
	#var scene_path = "res://Scenes/Rooms/"
	#if PlayerData.is_current_room_cleared():
		#scene_path += "room_without_enemies.tscn"
	#else:
		#scene_path += "room.tscn"
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node_or_null("Player")
	#if player and player.has_method("player"):
		#PlayerData.player_start_position = Vector2(player.position.x, -17)
	#else:
		#PlayerData.player_start_position = Vector2.ZERO
		#
	#var scene = load(scene_path).instantiate()
	#get_tree().change_scene_to_packed(scene)
	#
func load_next_room():
	PlayerData.next_room()
	var scene_path
	if PlayerData.is_current_room_cleared():
		scene_path = "res://Scenes/Rooms/room_without_enemies.tscn"
	else:
		scene_path = "res://Scenes/Rooms/room.tscn"
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node_or_null("Player")
	if player and player.has_method("player"):
		PlayerData.player_start_position = Vector2(player.position.x, -17)
	else:
		PlayerData.player_start_position = Vector2.ZERO

	# Change to the next room based on whether it's cleared
	get_tree().change_scene_to_file(scene_path)
	
	#var scene_resource = load(scene_path)
	#if scene_resource and scene_resource is PackedScene:
		#var scene = scene_resource.instantiate()
		#var current_scene = get_tree().current_scene
		#var player = current_scene.get_node_or_null("Player")
		#if player and player.has_method("player"):
			#PlayerData.player_start_position = Vector2(player.position.x, -17)
		#else:
			#PlayerData.player_start_position = Vector2.ZERO
		#get_tree().change_scene_to_file("res://Scenes/Rooms/room_without_enemies.tscn")
	#else:
		#print("Failed to load scene at path: ", scene_path)


#func reload_room(new_y_position: float = -17.0):
	#var current_scene = get_tree().current_scene
	#var player = current_scene.get_node_or_null("Player")
	#if player and player.has_method("player"):
		#PlayerData.player_start_position = Vector2(player.position.x, new_y_position)
	#else:
		#PlayerData.player_start_position = Vector2.ZERO
	#get_tree().reload_current_scene()
