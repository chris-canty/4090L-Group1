extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	if RoomInfo.curr_y != 0:
		visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
