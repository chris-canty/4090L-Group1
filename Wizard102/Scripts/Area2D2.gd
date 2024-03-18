extends Area2D

@onready var tilemap3: Node2D = get_node("../TileMap3")
@onready var tilemap4: Node2D = get_node("../TileMap4")

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
		reload_room(-170)

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
		tilemap3.visible = false
		tilemap4.visible = true
	else:
		# If the player has left the area, revert the visibility back
		tilemap3.visible = true
		tilemap4.visible = false

func reload_room(new_y_position: float = -170.0):
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node_or_null("Player")
	if player and player.has_method("player"):
		PlayerData.player_start_position = Vector2(player.position.x, new_y_position)
	else:
		PlayerData.player_start_position = Vector2.ZERO
	get_tree().reload_current_scene()
