extends Node2D
var cam_pos: Vector2 = Vector2(0,0)
var cam_zoom: float = 3.5
var cam_speed: float = 10
var bgm_volume: float = -22.0
enum States {COMBAT,EXPLORE}
var _state : int = States.EXPLORE

#Variables for Combat
var combatants: Array = []
var initiative: Array = []
var possible_targets: Array = []
var curr_turn: int = -1
var target: int = -1
var card_select: int = -1
var action_id: int = 0

var deck: Array = []
var hand: Array = []
var pass_ui = null
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _state == States.EXPLORE:
		cam_pos = $Player.position + Vector2(0,200)
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x, cam_zoom, cam_speed * delta)
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y, cam_zoom, cam_speed * delta)
	$Camera2D.position.x = lerp($Camera2D.position.x,cam_pos.x,cam_speed * delta)
	$Camera2D.position.y = lerp($Camera2D.position.y,cam_pos.y,cam_speed * delta)

func initiate_combat():
	_state = States.COMBAT
	$BGM.play()
	deck = $Player.deck
	deck.shuffle()
	combatants.push_back($Player)
	for e in get_tree().get_nodes_in_group("Enemy"):
		combatants.push_back(e)
	
	
