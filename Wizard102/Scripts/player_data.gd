extends Node

# Variable to store the player's start position
var player_start_position: Vector2 = Vector2.ZERO
var alt_deck : Array = ["Surge","Surge","Surge"]
var room_states: Array = [1] #initialize the first room with enemies
var current_room_index: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_room():
	current_room_index += 1
	if current_room_index >= room_states.size():
		room_states.append(1) #Assuming new rooms have enemies

func previous_room():
	current_room_index -= 1
	if current_room_index < 0:
		current_room_index = 0 #prevent invalid index
		
func clear_current_room():
	room_states[current_room_index] = 0
	
func is_current_room_cleared() -> bool:
	return room_states[current_room_index] == 0
