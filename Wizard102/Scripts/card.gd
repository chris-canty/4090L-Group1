extends Button
var cardscale: float = .1
var speed: float = 10
@export var action_id: String = ""
@export var mp_cost: int = 0
@export var target_type: int = 0
@export var enchant_type = "attack"
@export var damage_init = 0
@export var damage_ot = 0
@export var accuracy = 100
var is_enchant : bool = false
var item_mode = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Card.scale.x = lerp($Card.scale.x, cardscale, speed * delta)
	$Card.scale.y = lerp($Card.scale.y,cardscale, speed * delta)
	
func _on_mouse_entered():
	get_parent().move_child(self,-1)
	$hover.play()
	cardscale = .14

func _on_mouse_exited():
	cardscale = .1
	
func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and item_mode == false:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				get_parent().get_parent().select_card(self,action_id,mp_cost,target_type)
			MOUSE_BUTTON_RIGHT:
				get_parent().get_parent().discard(self)
