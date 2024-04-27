extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	if RoomInfo.curr_y == 4 && RoomInfo.curr_x != 2:
		visible = true
	else:
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
