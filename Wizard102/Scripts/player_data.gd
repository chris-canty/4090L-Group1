extends Node

# Variable to store the player's start position
var player_start_position: Vector2 = Vector2.ZERO
var deck : Array = ["Ember", "Heat Up", "Ember", "Ember"]
var alt_deck : Array = ["Surge","Surge","Surge"]

#var room_states: Array = [1] #initialize the first room with enemies
#var current_room_index: int = 0

#2D 5x5 array initialization
var room_states := Array()

# Store current position in the 2D array as a Vector2, starting bottom middle
var current_room_position: Vector2 = Vector2(2, 0)


var head : String
var body : String
var feet : String
var accessory_1 : String
var accessory_2 : String

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the 2D array with enemies present in all rooms
	for i in range(5):
		var row: Array = []
		for j in range(5):
			row.append(1)
		room_states.append(row)
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: Change the next_room and previous_room to directional changes (up down left right)
# Make the room_states array 2d 5x5, all initialized to enemies present first.
# Remove the current_room_index and instead use the position in the room_states array to track whether or not enemies are present
# Adjusted function to change rooms based on direction
func move_room(direction: Vector2):
	var new_x = clamp(current_room_position.x + direction.x, 0, 4)
	var new_y = clamp(current_room_position.y + direction.y, 0, 4)
	current_room_position.x = new_x
	current_room_position.y = new_y

func clear_current_room():
	room_states[current_room_position.y][current_room_position.x] = 0

func is_current_room_cleared() -> bool:
	return room_states[current_room_position.y][current_room_position.x] == 0

# Directional movement functions
func move_up():
	move_room(Vector2(0, 1))

func move_down():
	move_room(Vector2(0, -1))

func move_left():
	move_room(Vector2(-1, 0))

func move_right():
	move_room(Vector2(1, 0))
#func next_room():
	#current_room_index += 1
	#if current_room_index >= room_states.size():
		#room_states.append(1) #Assuming new rooms have enemies
#
#func previous_room():
	#current_room_index -= 1
	#if current_room_index < 0:
		#current_room_index = 0 #prevent invalid index
		#
#func clear_current_room():
	#room_states[current_room_index] = 0
	#
#func is_current_room_cleared() -> bool:
	#return room_states[current_room_index] == 0
