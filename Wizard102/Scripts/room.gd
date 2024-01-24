extends Node2D
var cam_pos: Vector2 = Vector2(0,0)
var cam_zoom: float = 5
var cam_speed: float = 10
var bgm_volume: float = -22.0
enum States {COMBAT,EXPLORE}
var _state : int = States.EXPLORE
var player_spot: Vector2 = Vector2(-80,-109)
var card_pos = [Vector2(-60,-75),Vector2(-40,-75),Vector2(-20,-75),Vector2(0,-75),Vector2(20,-75),Vector2(40,-75),Vector2(60,-75)]
var pass_pos = Vector2(-60,0)

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
var hand_ui: Array = []
var pass_ui = null
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _state == States.EXPLORE:
		cam_zoom = 5
		cam_pos = $Player.position
	var card_speed = 20
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x, cam_zoom, cam_speed * delta)
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y, cam_zoom, cam_speed * delta)
	$Camera2D.position.x = lerp($Camera2D.position.x,cam_pos.x,cam_speed * delta)
	$Camera2D.position.y = lerp($Camera2D.position.y,cam_pos.y,cam_speed * delta)
	for i in range(len(hand)):
		hand_ui[i].position.x = lerp(hand_ui[i].position.x,card_pos[i].x,card_speed * delta)
		hand_ui[i].position.y = lerp(hand_ui[i].position.y,card_pos[i].y,card_speed * delta)

func initiate_combat():
	_state = States.COMBAT
	$BGM.play()
	deck = $Player.deck
	deck.shuffle()
	$Player.move_character(player_spot)
	$Player/AnimatedSprite2D.play("idle_side")
	$Player/AnimatedSprite2D.flip_h = false
	combatants.push_back($Player)
	var y_coor = -120
	for e in get_tree().get_nodes_in_group("Enemy"):
		combatants.push_back(e)
		e.move_character(Vector2(80,y_coor))
		y_coor += 60
	for c in combatants:
		initiative.push_back(100 - c.SPD)
		c.enable_bars()
		c.in_combat = true
		
	#Pass Button Being created
	
	print(combatants)
	print(initiative)
	cam_pos = Vector2(0,-100)
	cam_zoom = 4.5
	await get_tree().create_timer(2.0).timeout
	next_turn()
	
func next_turn():
	'''
	Switches the turn to the next combatant
	'''
	if combatants.size() == 1:
		$Player.in_combat = false
		_state = States.EXPLORE
		$Player.disable_bars()
		bgm_volume = -45.0
		pass_ui.queue_free()
		pass_ui = null
		await get_tree().create_timer(3.0).timeout
		$BGM.stop()
		return
	curr_turn = find_turn()
	print(curr_turn)
	cam_pos = combatants[curr_turn].position - Vector2(0,20)
	cam_zoom = 6
	#Player
	if curr_turn == 0:
		player_turn()
	else:
		combatants[curr_turn].MP += 1
		if combatants[curr_turn].MP > combatants[curr_turn].MaxMP:
			combatants[curr_turn].MP = combatants[curr_turn].MaxMP
	
	
func find_turn():
	'''
	Used for Finding whos next in the turn order
	'''
	var fast = 1000
	var combatant = -1
	
	#finding the combatant with the lowest initiative
	for i in range(initiative.size()):
		if initiative[i] < fast:
			fast = initiative[i]
			combatant = i
	
	#if it is your turn, the initiative is reset, otherwise subtract the lowest initiative
	for i in range(initiative.size()):
		if combatant == i:
			initiative[i] = (100 - combatants[i].SPD)
		else:
			initiative[i] -= fast
			
	return combatant

func player_turn():
	print("Player Turn")
	$Player.MP += 1
	if $Player.MP > $Player.MaxMP:
		$Player.MP = $Player.MaxMP
	while hand.size() < 7 and deck.size() >= 1:
		hand.push_back(deck.pop_front())
	for card: int in hand:
		match card:
			1:
				var scene = load("res://Scenes/Cards/ember_card.tscn")
				var instance = scene.instantiate()
				$Player.add_child(instance)
				await instance._ready()
				instance.position = Vector2(0,0)
				if $Player.MP < 1:
					instance.modulate = Color("3b3b3b")
				instance.get_node("Card").scale = Vector2(0,0)
				hand_ui.push_back(instance)

func select_card(button: Button):
	$Select.play()
	var target_type = -1
	var counter = 0 
	for card in hand_ui:
		if button == card:
			break
		counter += 1
	print(hand[counter])
	card_select = counter
	match hand[counter]:
		1:
			print("Single Target")
			if $Player.MP < 1:
				return
			action_id = 1
			target_type = 1
	for card in hand_ui:
		card.visible = false
	
	for i in range(len(combatants)):
		if i == 0:
			if target_type == 0:
				var scene = load("res://Scenes/UI/target.tscn")
				var instance = scene.instantiate()
				$Player.add_child(instance)
				await instance._ready()
				instance.position = $Player.position
				possible_targets.push_back(instance)
				break
		else:
			var scene = load("res://Scenes/UI/target.tscn")
			var instance = scene.instantiate()
			combatants[i].add_child(instance)
			await instance._ready()
			instance.position = combatants[i].position - Vector2(6,5)
			possible_targets.push_back([i,instance])
	cam_zoom = 4.5
	cam_pos = Vector2(0,-100)
