extends Node

@onready var room_template = preload("res://Scenes/Rooms/room.tscn")
@onready var boss_room_template = preload("res://Scenes/Rooms/boss_room.tscn")
@onready var card_chests = preload("res://Scenes/Rooms/loot_drop.tscn")
@onready var rng = RandomNumberGenerator.new()

const Y_UPPER = -50
const Y_LOWER = -125
const X_UPPER = 150
const X_LOWER = -150

var curr_floor = 1
var rooms : Array = []
var boss_room
var enemy_scenes : Array = []

var curr_x : int
var curr_y : int

var enemy_types = {
	1: ["slime"]
}

var card_drops = ["Bolt", "Frost", "Stone", "Blast", "Dark", "Ray", "Quake", "Chill", "Stun"]

var boss_type = {
	1 : ["slime_king"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_floor():
	rooms = []
	#Loading all possible enemies on this floor
	for enemy in enemy_types[curr_floor]:
		var en_scn = load("res://Scenes/Characters/" + enemy + ".tscn")
		enemy_scenes.append(en_scn)
		
	#Generating random room scenes
	for i in range(5):
		var row = []
		for j in range(5):
			var new_room = room_template.instantiate()
			var names = []
			#Spawning in enemies
			for spawn in range(1,rng.randi_range(0,3)):
				var en = enemy_scenes[rng.randi_range(0,len(enemy_scenes) - 1)]
				var counter = 2
				en = en.instantiate()
				var temp_name = en.get_name()
				var temp = ''
				if names.has(temp_name):
					temp = temp_name + " " + str(counter)
				while names.has(temp):
					temp = temp_name + " " + str(counter)
					counter += 1
				names.append(temp)
				en.set_name(temp)
				en.MaxHP = en.MaxHP + rng.randi_range(-2,2)
				en.HP = en.MaxHP
				en.SPD = en.SPD + rng.randi_range(-2,2)
				en.position = Vector2(rng.randi_range(X_LOWER, X_UPPER),rng.randi_range(Y_LOWER,Y_UPPER))
				new_room.add_child(en)
			#Spawning in chests
			for spawn in range(1,rng.randi_range(0,3)):
				var loot = card_chests.instantiate()
				loot.randomLoot = card_drops
				loot.position = Vector2(rng.randi_range(X_LOWER, X_UPPER),rng.randi_range(Y_LOWER,Y_UPPER))
				new_room.add_child(loot)
			row.append(new_room)
		rooms.append(row)
	boss_room = boss_room_template.instantiate()
	var en = load("res://Scenes/Characters/" + boss_type[curr_floor][0] + ".tscn")
	en = en.instantiate()
	en.position = Vector2(0,-75)
	boss_room.add_child(en)
	
				
func load_room(x: int, y: int):
	if y == 5:
		return boss_room
	return rooms[x][y]
	
