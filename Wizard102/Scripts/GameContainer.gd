extends Node2D

@onready var screen = $"Black Screen/Fade"
var current_node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loaded Main Game Container")
	await RoomInfo.generate_floor()
	load_room_first()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_room_first():
	RoomInfo.curr_x = 2
	RoomInfo.curr_y = 0
	current_node = await RoomInfo.load_room(2,0)
	add_child(current_node)
	for enemy in get_node("basic_room").get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	get_node("basic_room").get_node("Player").position = PlayerData.player_start_position
	screen.play("fade_in")
	
func load_boss_room():
	current_node = await RoomInfo.load_room(2,5)
	RoomInfo.curr_x = 2
	RoomInfo.curr_y = 5
	var player_pos = PlayerData.player_start_position
	await add_child(current_node)
	get_node("basic_room").get_node("Player").position = player_pos
	screen.play("fade_in")
		
func load_room(x: int, y: int):
	screen.play("fade_out")
	get_node("basic_room").isLoading = true
	$"Black Screen".visible = true
	remove_child(current_node)
	if RoomInfo.curr_y == 5:
		RoomInfo.boss_room = current_node
	else:
		RoomInfo.rooms[RoomInfo.curr_x][RoomInfo.curr_y] = current_node
	if x == 2 and y == 5:
		RoomInfo.curr_x = 2
		RoomInfo.curr_y = 5
		load_boss_room()
		return
	current_node = await RoomInfo.load_room(x,y)
	RoomInfo.curr_x = x
	RoomInfo.curr_y = y
	var player_pos = PlayerData.player_start_position
	await add_child(current_node)
	get_node("basic_room").get_node("Player").position = player_pos
	screen.play("fade_in")
	print(x,y)


func _on_fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		$"Black Screen".visible = false
		get_node("basic_room").isLoading = false
	
