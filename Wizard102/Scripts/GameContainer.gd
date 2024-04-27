extends Node2D

@onready var screen = $"Black Screen/Fade"
@onready var ui_rooms = $"room_ui/VBoxContainer/rooms"
@onready var ui_boss = $"room_ui/VBoxContainer/Boss"
var current_node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loaded Main Game Container")
	await RoomInfo.generate_floor()
	for node in ui_rooms.get_children():
		node.modulate = Color("000000")
	load_room_first()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_ui():
	if RoomInfo.curr_y == 5:
		ui_boss.modulate = Color("ffffff")
	else:
		ui_boss.modulate = Color("000000")
	for node in ui_rooms.get_children():
		if node.get_name() == (str(RoomInfo.curr_x) + "-" + str(RoomInfo.curr_y)):
			node.modulate = Color("ffffff")
		else:
			node.modulate = Color("000000")
			
func load_room_first():
	RoomInfo.curr_x = 2
	RoomInfo.curr_y = 0
	current_node = await RoomInfo.load_room(2,0)
	add_child(current_node)
	for enemy in get_node("basic_room").get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	get_node("basic_room").get_node("Player").position = PlayerData.player_start_position
	set_ui()
	screen.play("fade_in")
	
func load_boss_room():
	current_node = await RoomInfo.load_room(2,5)
	RoomInfo.curr_x = 2
	RoomInfo.curr_y = 5
	var player_pos = PlayerData.player_start_position
	await add_child(current_node)
	get_node("basic_room").get_node("Player").position = player_pos
	set_ui()
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
	var player_dir = PlayerData.player_start_direction
	await add_child(current_node)
	get_node("basic_room").get_node("Player").position = player_pos
	get_node("basic_room").get_node("Player").direction = player_dir
	set_ui()
	screen.play("fade_in")
	print(x,y)


func _on_fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		$"Black Screen".visible = false
		get_node("basic_room").isLoading = false
	
