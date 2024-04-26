extends Node2D

#Status Effects Scripts
const Boost_ATK = preload("res://Scripts/Status Effects/boost_atk.gd")
const DoT = preload("res://Scripts/Status Effects/dot.gd")
const Stun = preload("res://Scripts/Status Effects/stun.gd")

var cam_pos: Vector2 = Vector2(0,0)
var cam_zoom: float = 1
var cam_speed: float = 10
var bgm_volume: float = -25.0
enum States {COMBAT,EXPLORE,INVENTORY}
var _state : int = States.EXPLORE
var player_spot: Vector2 = Vector2(-80,-79)
var enemy_spot: Array = [Vector2(80,-90),Vector2(80,-150),Vector2(80,-30), Vector2(120,-120),Vector2(120,-60)]
var card_pos = [Vector2(-70,-85),Vector2(-50,-85),Vector2(-30,-85),Vector2(-10,-85),Vector2(10,-85),Vector2(30,-85),Vector2(50,-85)]
var card_pos1 = [Vector2(-70,-85),Vector2(-50,-85),Vector2(-30,-85),Vector2(-10,-85),Vector2(10,-85),Vector2(30,-85),Vector2(50,-85)]
var alt_card_pos = [Vector2(20,-12),Vector2(40,-12),Vector2(60,-12)]
var pass_pos = Vector2(-60,-10)
var temp_init = 0

#Variables for Combat
enum Combat {Idle,P_Select,P_Enchant,P_Target,P_Action,Enemy}
var isLoading : bool = true
var _cState: int = Combat.Idle
var rng = RandomNumberGenerator.new()
var combatants: Array = []
var initiative: Array = []
var possible_targets: Array = []
var curr_turn: int = -1
var target: int = -1
var card_select: int = -1
var action_id: String = ""
var alt_action_id: String = ""
var alt_action_index = -1
@onready var init_ui = $TurnUI/Initiative

var deck: Array = []
var hand: Array = []
var alt_hand: Array = []
var alt_deck: Array = []
var hand_ui: Array = []
var hand_enchants: Array = ["","","","","","",""]
var alt_hand_ui: Array = []
var pass_ui = null
var active_card : Button
# Called when the node enters the scene tree for the first time.
var isOpened = false
func _ready():
	print("Loading Room")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deck = PlayerData.deck.duplicate(true)	
	$TurnUI/Label.text = "FPS: " + str(Engine.get_frames_per_second())
	if _state == States.EXPLORE:
		$TurnUI.visible = false
		cam_zoom = 5
		cam_pos = $Player.position
		for card in hand_ui:
			card.queue_free()
		hand_ui.clear()
		possible_targets.clear()
		target = -1
		card_select = -1
		action_id = ""
	elif _state == States.INVENTORY:
		if Input.is_action_just_pressed("i"):
			show_card()
			return
	elif _state == States.COMBAT:
		$TurnUI.visible = true
		var counter = 0
		for c in range(len(combatants)):
			if combatants[c] == null:
				init_ui.get_child(c).queue_free()
			else:
				var init_child = init_ui.get_child(c).get_node("Init_Bar")
				init_child.value = lerp(init_child.value,float(100 - initiative[c]),10 * delta)
		while counter < len(combatants):
			if combatants[counter] == null:
				print("Dead")
				combatants.pop_at(counter)
				initiative.pop_at(counter)
			else:
				counter += 1
		if curr_turn >= len(combatants):
			curr_turn = len(combatants) - 1
		if target >= len(combatants):
			target = len(combatants) - 1
		if Input.is_action_pressed("ui_cancel") and (_cState == Combat.P_Target or _cState == Combat.P_Enchant):
			$cancel.play()
			active_card = null
			initiative[0] = temp_init
			init_ui.get_child(0).get_node("Init_Bar").modulate = Color("ffffff")
			for card in hand_ui:
				card.queue_free()
			for card in alt_hand_ui:
				card.queue_free()
			for t in possible_targets:
				t[1].queue_free()
			hand_ui.clear()
			alt_hand_ui.clear()
			possible_targets.clear()
			target = -1
			card_select = -1
			action_id = ""
			$Camera2D/CText.text = ""
			player_turn()
	var card_speed = 20
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x, cam_zoom, cam_speed * delta)
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y, cam_zoom, cam_speed * delta)
	$Camera2D.position.x = lerp($Camera2D.position.x,cam_pos.x,cam_speed * delta)
	$Camera2D.position.y = lerp($Camera2D.position.y,cam_pos.y,cam_speed * delta)
	$BGM.volume_db = lerp($BGM.volume_db,bgm_volume,5 * delta)
	print(len(hand_ui))
	print(len(card_pos))
	
	for i in range(len(hand_ui)):
		var card_pos2 = Vector2(-70 + 20*i,-85);
		#card_pos1 = [Vector2(-70,-85),Vector2(-50,-85),Vector2(-30,-85),Vector2(-10,-85),Vector2(10,-85),Vector2(30,-85),Vector2(50,-85)]
		if isOpened:
			hand_ui[i].position.x = lerp(hand_ui[i].position.x,card_pos2.x,card_speed * delta)
			hand_ui[i].position.y = lerp(hand_ui[i].position.y,card_pos2.y,card_speed * delta)
		else:
			hand_ui[i].position.x = lerp(hand_ui[i].position.x,card_pos[i].x,card_speed * delta)
			hand_ui[i].position.y = lerp(hand_ui[i].position.y,card_pos[i].y,card_speed * delta)
	for i in range(len(alt_hand_ui)):
		alt_hand_ui[i].position.x = lerp(alt_hand_ui[i].position.x,alt_card_pos[i].x,card_speed * delta)
		alt_hand_ui[i].position.y = lerp(alt_hand_ui[i].position.y,alt_card_pos[i].y,card_speed * delta)
	if Input.is_action_just_pressed("i"):
			show_card()
			return
func initiate_combat():
	_state = States.COMBAT
	$Camera2D.limit_left = -100000
	$Camera2D.limit_right = 100000
	$Camera2D.limit_top = -10000
	$Camera2D.limit_bottom = 10000
	$BGM.play()
	#deck = PlayerData.deck.duplicate(true)
	#deck.shuffle()
	alt_deck = PlayerData.alt_deck.duplicate(true)
	alt_deck.shuffle()
	$Player.direction = "right"
	$Player.move_character(player_spot)
	$Player/AnimatedSprite2D.play("idle_side")
	$Player/AnimatedSprite2D.flip_h = false
	combatants.push_back($Player)
	var counter = 0
	for e in get_tree().get_nodes_in_group("Enemy"):
		combatants.push_back(e)
		e.move_character(enemy_spot[counter])
		counter += 1
	for c in combatants:
		initiative.push_back(100 - c.SPD)
		c.enable_bars()
		c.in_combat = true
		
	#Pass Button Being created
	
	print(combatants)
	print(initiative)
	for i in range(len(combatants)):
		var turn = load("res://Scenes/UI/turn.tscn")
		var turn_i = turn.instantiate()
		turn_i.get_node("Name").text = combatants[i].get_name()
		turn_i.get_node("Init_Bar").value = 0
		init_ui.add_child(turn_i)
	var scene = load("res://Scenes/UI/pass_card.tscn")
	pass_ui = scene.instantiate()
	pass_ui.visible = false
	$Player.add_child(pass_ui)
	cam_pos = Vector2(0,-100)
	cam_zoom = 4.5
	await get_tree().create_timer(2.0).timeout
	next_turn()
	
func show_card():
	if _state == States.COMBAT:
		# If not in EXPLORE state, do not show cards.
		return

	if isOpened:
		# If the inventory is already open, close it by clearing all cards.
		for card_instance in hand_ui:
			card_instance.queue_free()
		hand_ui.clear()
		isOpened = false
		_state = States.EXPLORE
		print("Inventory closed")
		return
	else:
		_state = States.INVENTORY
		isOpened = true
		print("Inventory open")
		var xPos = -15
		var deckSize = deck.size()
		xPos = xPos - deckSize * 5
		for card in deck:
			var load_str = "res://Scenes/Cards/" + card.replace(' ', '').to_lower() + "_card.tscn"
			
			var scene = load(load_str)
			var lootInstance = scene.instantiate()
			$Player.add_child(lootInstance)  # Ensure this is called before setting position if using global_position
			hand_ui.append(lootInstance)  # Store the instance in the hand_ui array for later reference.
		await get_tree().create_timer(2).timeout

	
func next_turn():
	'''
	Switches the turn to the next combatant
	'''
	_cState = Combat.Idle
	$Camera2D/CText.text = ""
	var player = $Player
	if player == null:
		get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
		return
	if combatants.size() == 1:
		if player == null:
			get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
			return
		PlayerData.clear_current_room()
		$Player.in_combat = false
		PlayerData.alt_deck = alt_deck + alt_hand
		_state = States.EXPLORE
		init_ui.get_child(0).queue_free()
		$Player.disable_bars()
		$Player.status_effects.clear()
		for s in $Player.status_ui.get_children():
			s.texture = null
		bgm_volume = -45.0
		pass_ui.queue_free()
		pass_ui = null
		$Camera2D.limit_left = -223
		$Camera2D.limit_right = 223
		$Camera2D.limit_top = -219
		$Camera2D.limit_bottom = 11
		await get_tree().create_timer(3.0).timeout
		$BGM.stop()
		return
	curr_turn = find_turn()
	print(curr_turn)
	await combatants[curr_turn].run_status()		
	if combatants[curr_turn].is_dead == true:
		combatants[curr_turn].disable_bars()
		combatants.pop_at(curr_turn)
		initiative.pop_at(curr_turn)
		init_ui.get_child(curr_turn).queue_free()
		next_turn()
		return
	if combatants[curr_turn].is_stun == true:
		combatants[curr_turn].is_stun = false
		initiative[curr_turn] = 100 - combatants[curr_turn].SPD
		init_ui.get_child(curr_turn).get_node("Init_Bar").value = 0
		next_turn()
		return
	#Player
	if curr_turn == 0:
		player_turn()
	else:
		cam_pos = combatants[curr_turn].position + Vector2(0,-20)
		cam_zoom = 6
		_cState = Combat.Enemy
		combatants[curr_turn].MP += 1
		if combatants[curr_turn].MP > combatants[curr_turn].MaxMP:
			combatants[curr_turn].MP = combatants[curr_turn].MaxMP
		#$Camera2D/CText.text = "Pass"
		await get_tree().create_timer(0.5).timeout
		var result: Array = combatants[curr_turn].enemy_ai(combatants) 
		print(result)
		if result[0] == null:
			for c in combatants:
				c.disable_bars()
			$Camera2D/CText.text = "Pass"
			await get_tree().create_timer(1.0).timeout
			select_pass()
		else:
			for i in range(0,len(combatants)):
				if combatants[i] == result[1]:
					target = i
			action_id = result[0].action_id
			active_card = result[0]
			execute_action()
	
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
			initiative[i] = 0
		else:
			initiative[i] -= fast
			
	return combatant

func player_turn():
	print("Player Turn")
	var scene
	var instance
	cam_pos = combatants[curr_turn].position - Vector2(0,40)
	cam_zoom = 6
	if _cState == Combat.Idle:
		$Player.MP += 1
	_cState = Combat.P_Select
	if $Player.MP > $Player.MaxMP:
		$Player.MP = $Player.MaxMP
	while hand.size() < 7 and deck.size() >= 1:
		hand.push_back(deck.pop_front())
	while alt_hand.size() < 3 and alt_deck.size() >= 1:
		alt_hand.push_back(alt_deck.pop_front())
	for card: String in hand:
		var mp_cost
		var load_str = card.replace(' ', '')
		load_str = load_str.to_lower()
		load_str = "res://Scenes/Cards/" + load_str + "_card.tscn"
		scene = load(load_str)
		instance = scene.instantiate()
		mp_cost = instance.mp_cost
		$Player.add_child(instance)
		await instance._ready()
		instance.position = Vector2(0,0)
		if $Player.MP < mp_cost:
			instance.modulate = Color("3b3b3b")
		instance.get_node("Card").scale = Vector2(0,0)
		hand_ui.push_back(instance)
	for i in range(len(hand_ui)):
		if hand_enchants[i] != "":
			enchant_card(hand_ui[i],hand_enchants[i])
	for card: String in alt_hand:
		var mp_cost
		var load_str = card.replace(' ', '')
		load_str = load_str.to_lower()
		load_str = "res://Scenes/Cards/" + load_str + "_card.tscn"
		scene = load(load_str)
		instance = scene.instantiate()
		mp_cost = instance.mp_cost
		$Player.add_child(instance)
		await instance._ready()
		instance.position = Vector2(0,0)
		if $Player.MP < mp_cost:
			instance.modulate = Color("3b3b3b")
		instance.get_node("Card").scale = Vector2(0,0)
		alt_hand_ui.push_back(instance)
			
			
	pass_ui.position = pass_pos
	pass_ui.get_node("Card").scale = Vector2(0,0)
	pass_ui.visible = true

func select_pass():
	if _cState != Combat.Enemy:
		$Select.play()
	execute_action()

func discard(card: Button):
	print(hand)
	for i in range(len(hand_ui)):
		if hand_ui[i] == card:
			hand_ui[i].queue_free()
			hand_ui.pop_at(i)
			hand.pop_at(i)
			return
			
func enchant_card(button: Button, alt_a_id: String):
	button.get_node("Card").texture = load("res://Assets/Card/" + str(button.action_id) + "_" + str(alt_a_id) + ".png")
	match alt_a_id:
		"Surge":
			button.damage_init += 5
	button.is_enchant = true
	
	
			
func select_card(button: Button, a_id: String, mp_cost: int, target_type: int):
	
	#Enchanting Cards
	if _cState == Combat.P_Enchant:
		if button.modulate == Color("ffffff"):
			$enchant.play()
			for i in range(len(hand_ui)):
				if hand_ui[i] == button:
					hand_enchants[i] = alt_action_id
			enchant_card(button, alt_action_id)
			alt_hand_ui.pop_at(alt_action_index)
			alt_hand.pop_at(alt_action_index)
			#Resetting Stuff
			for card in hand_ui:
				card.modulate = Color("ffffff")
			for card in alt_hand_ui:
				card.visible = true
			_cState = Combat.P_Select
		else:
			$cancel.play()
		return
	_cState = Combat.P_Target
	var counter = 0 
	for card in hand_ui:
		if button == card:
			break
		counter += 1
	print(hand[counter])
	card_select = counter
	if $Player.MP < mp_cost:
		$cancel.play()
		return
	$Select.play()
	match target_type:
		0:
			#self
			$Camera2D/CText.text = "Confirm Cast"
		1:
			#Single Target
			$Camera2D/CText.text = "Select Target"
		2:
			#AOE
			$Camera2D/CText.text = "Confirm Cast"
	action_id = a_id
	for card in hand_ui:
		card.visible = false
	for card in alt_hand_ui:
		card.visible = false
	pass_ui.visible = false
	for i in range(len(combatants)):
		if i == 0:
			if target_type == 0:
				var scene = load("res://Scenes/UI/target.tscn")
				var instance = scene.instantiate()
				$Player.add_child(instance)
				possible_targets.push_back([i,instance])
				break
		else:
			var scene = load("res://Scenes/UI/target.tscn")
			var instance = scene.instantiate()
			combatants[i].add_child(instance)
			#instance.position 
			possible_targets.push_back([i,instance])
	cam_zoom = 4.5
	cam_pos = Vector2(0,-100)
	init_ui.get_child(0).get_node("Init_Bar").modulate = Color("ffff51")
	temp_init = initiative[0]
	initiative[0] = 100 - $Player.SPD
	active_card = button
	
func select_alt_card(button : Button, a_id: String, mp_cost: int):
	print("Alt Card")
	$Select.play()
	_cState = Combat.P_Enchant
	for card in hand_ui:
		if card.enchant_type.match(button.enchant_type) == false or card.is_enchant:
			card.modulate = Color("3b3b3b")
	for card in alt_hand_ui:
		card.visible = false
	alt_action_id = a_id
	for i in range(len(alt_hand_ui)):
		if alt_hand_ui[i] == button:
			alt_action_index = i
			print(i)
	

func select_target(target_button):
	$Select.play()
	initiative[0] = temp_init
	init_ui.get_child(0).get_node("Init_Bar").modulate = Color("ffffff")
	_cState = Combat.P_Action
	var counter = 0
	for t in possible_targets:
		if t[1] == target_button:
			break
		counter += 1
	target = possible_targets[counter][0] 
	execute_action()
	
	
'''
FUNCTIONS FOR ACTIONS	
'''

func moveCamAction(type: String):
	match type:
		"single":
			cam_zoom = 6
			cam_pos = combatants[target].position
		"multi":
			cam_zoom = 5
	await get_tree().create_timer(1.0).timeout
	$Camera2D/CText.text = ""
	
func cardSingleTarget( 	rawDamage: int ,accuracy : int, 
						mp_cost: int, element: String, addrScen: String, 
						 vector:Vector2=Vector2(0,0)):
	var roll = rng.randi_range(1,100)
	var addrText = "res://Scenes/UI/damage.tscn"
	var damage: float = 0
	var t_color
	var t_shadow
	match element:
		"fire":
			t_color = "d5621f"
			t_shadow = "ff0000"
		"lightning":
			t_color = "c3d511"
			t_shadow = "ef9926"
		"ice":
			t_color = "00ffff"
			t_shadow = "0000ff"
		"earth":
			t_color = "6e5003"
			t_shadow = "005000"
		"arcane":
			t_color = "#4fffbe"
			t_shadow = "#61c780"
		"dark":
			t_color = "#8e43f7"
			t_shadow = "#572f8f"
		"light":
			t_color = "#f5ff69"
			t_shadow = "#aab058"
	var scene = load(addrScen)
	var instance = scene.instantiate()
	instance.position = combatants[target].position -vector
	add_child(instance)
	#Damage Calculations
	var text = load(addrText)
	var text_instance = text.instantiate()
	#print("CURRENT TURN:")
	#print(curr_turn)
	# Having some problems with curr_turn cause combatants out of bounds
	if roll <= accuracy:
		damage = combatants[curr_turn].atk_status(rawDamage,element)
		combatants[curr_turn].MP -= mp_cost
		text_instance.get_node("Text").text = str(int(damage))
		text_instance.get_node("Text").set("theme_override_colors/font_color",Color(t_color))
		text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color(t_shadow))
		if _cState == Combat.P_Action:
			hand.pop_at(card_select)
			hand_enchants.pop_at(card_select)
			hand_enchants.push_back("")
			
	else:
		damage = 0
		text_instance.get_node("Text").text = "Miss"
		combatants[target].velocity.x = 700
		
	#wait for animation
	await instance.display_damage
	#perform damage
	combatants[target].take_damage(int(damage))
	#show damage
	combatants[target].add_child(text_instance)
	await instance.anim_done
	
	if combatants[target].is_dead == true:
		combatants.pop_at(target)
		initiative.pop_at(target)
		init_ui.get_child(target).queue_free()
		print(combatants)
	return [(roll <= accuracy),float(damage)/rawDamage]

func cardAoeTarget(rawDamage: int ,accuracy : int, 
					mp_cost: int, element: String, addrScen: String):
	var dam_vals = []
	var damages = []
	var damage
	var instance
	var t_color
	var t_shadow
	match element:
		"fire":
			t_color = "d5621f"
			t_shadow = "ff0000"
		"lightning":
			t_color = "c3d511"
			t_shadow = "ef9926"
		"ice":
			t_color = "00ffff"
			t_shadow = "0000ff"
		"earth":
			t_color = "6e5003"
			t_shadow = "005000"
		"light":
			t_color = "#f5ff69"
			t_shadow = "#aab058"
		"arcane":
			t_color = "#4fffbe"
			t_shadow = "#61c780"
		"dark":
			t_color = "#8e43f7"
			t_shadow = "#572f8f"
	var scene = load(addrScen)
	var hit = false
	for i in range(1,len(combatants)):
		instance = scene.instantiate()
		instance.position = combatants[i].position
		add_child(instance)
		#Damage Calculations
		var text = load("res://Scenes/UI/damage.tscn")
		var text_instance = text.instantiate()
		var roll = rng.randi_range(1,100)
		print(roll)
		if roll <= accuracy:
			if hit == false:
				damage = combatants[curr_turn].atk_status(rawDamage,element)
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
					hand_enchants.pop_at(card_select)
					hand_enchants.push_back("")
				combatants[curr_turn].MP -= mp_cost
				hit = true
			text_instance.get_node("Text").text = str(int(damage))
			text_instance.get_node("Text").set("theme_override_colors/font_color",Color(t_color))
			text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color(t_shadow))
			dam_vals.push_back(int(damage))
		else:
			dam_vals.push_back(0)
			text_instance.get_node("Text").text = "Miss"
			combatants[i].velocity.x = 700
		damages.push_back(text_instance)
	await instance.display_damage
	for i in range(1,len(combatants)):
		combatants[i].take_damage(dam_vals[i-1])
		combatants[i].add_child(damages[i-1])
	await instance.anim_done
	print(combatants)
	return hit
	
	
func cardBuff(multiplier: float, element: String, info: String, icon: String):
	var text = load("res://Scenes/UI/effect.tscn")
	var text_instance = text.instantiate()
	var boost = Boost_ATK.new()
	boost.element = element
	boost.proc_id = 1
	boost.rounds = -1
	boost.augment = multiplier
	boost.icon = icon
	combatants[target].status_effects.push_back(boost)
	if _cState == Combat.P_Action:
		hand.pop_at(card_select)
		hand_enchants.pop_at(card_select)
		hand_enchants.push_back("")
	text_instance.get_node("Text").text = info
	combatants[target].add_child(text_instance)
	return boost

func cardDoT(over_time: int,rounds: int, element: String):
	var effect = load("res://Scenes/UI/effect.tscn")
	var effect_instance = effect.instantiate()
	var dot_effect = DoT.new()
	dot_effect.element = element
	dot_effect.proc_id = 0
	dot_effect.rounds = rounds
	dot_effect.icon = "dot"
	dot_effect.damage_total = over_time
	dot_effect.damage_remaining = over_time
	combatants[target].status_effects.push_back(dot_effect)
	var effect_string = "[center]" + str(over_time)
	match element:
		"fire":
			effect_string += " [img width=12]res://Assets/Icons/Fire.png[/img] "
	effect_string += "[img width=12]res://Assets/Icons/Attack.png[/img] " + str(rounds) + " [img width=12]res://Assets/Icons/Rounds.png[/img][/center]"
	effect_instance.get_node("Text").text  = effect_string
	combatants[target].add_child(effect_instance)		

func cardStun(rounds: int):
	var effect = load("res://Scenes/UI/effect.tscn")
	var effect_instance = effect.instantiate()
	var stun_effect = Stun.new()
	stun_effect.element = "universal"
	stun_effect.proc_id = 0
	stun_effect.rounds = rounds
	stun_effect.icon = "stun"
	combatants[target].status_effects.push_back(stun_effect)
	var effect_string = "[center] Stun " + str(rounds) + " [img width=12]res://Assets/Icons/Rounds.png[/img][/center]"
	effect_instance.get_node("Text").text  = effect_string
	combatants[target].add_child(effect_instance)

func execute_action():
	var scene
	var instance
	var text
	var text_instance
	var damage
	var accuracy
	var nameSpell
	var status
	var addrScen
	var vector = Vector2(0,0)
	var color
	var shadow
	var raw
	var roll = rng.randi_range(1,100)
	var mp_cost
	for t in possible_targets:
		t[1].queue_free()
	if action_id == "":
		#Pass
		for card in hand_ui:
			card.queue_free()
		for card in alt_hand_ui:
			card.queue_free()
		hand_ui.clear()
		alt_hand_ui.clear()
		possible_targets.clear()
		pass_ui.visible = false
		for c in combatants:
			await c.enable_bars()
		initiative[curr_turn] = 100 - combatants[curr_turn].SPD
		init_ui.get_child(curr_turn).get_node("Init_Bar").value = 0
		next_turn()
		return
	for c in combatants:
		await c.disable_bars()
	$Camera2D/CText.text = action_id
	match action_id:
		"Ember":
			await moveCamAction("single")
			await cardSingleTarget(50, active_card.accuracy, active_card.mp_cost, "fire", "res://Scenes/Effects/fire.tscn",Vector2(0,0))
		"Bolt":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "lightning", "res://Scenes/Effects/lightning.tscn", Vector2(0,58))
		"Frost":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "ice", "res://Scenes/Effects/ice.tscn", Vector2(0,0))
		"Stone":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "earth", "res://Scenes/Effects/earth.tscn", Vector2(0,0))
		"Blast":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "arcane", "res://Scenes/Effects/arcane.tscn", Vector2(0,0))
		"Dark":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "dark", "res://Scenes/Effects/dark.tscn", Vector2(0,0))
		"Ray":
			await moveCamAction("single")
			await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "light", "res://Scenes/Effects/light.tscn", Vector2(0,0))
		"Burn":
			#Burn I
			await moveCamAction("single")
			var res = await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "fire", "res://Scenes/Effects/fire.tscn", Vector2(0,0))
			if res[0] == true:
				print(res[1])
				await cardDoT((active_card.damage_ot * res[1]), 2,"fire")
		"Quake":
			await moveCamAction("multi")
			await cardAoeTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "earth", "res://Scenes/Effects/earth.tscn")
		"Heat Up":
			#Heat Up I
			raw = 1.4
			nameSpell = "Heat Up"
			status = "fire"
			addrScen = "[center]+40% to Next [img width=12]res://Assets/Icons/Fire.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			await moveCamAction("single")
			await cardBuff(raw, status, addrScen, "good")
			
		"Charge":
			#Charge I	
			raw = 1.45
			nameSpell = "Charge"
			status = "lightning"
			addrScen = "[center]+45% to Next [img width=12]res://Assets/Icons/Lightning.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			await moveCamAction("single")
			await cardBuff(raw, status, addrScen, "good")
			
		"Cooldown":
			#Cooldown I
			raw = 1.35
			status = "ice"
			addrScen = "[center]+35% to Next [img width=12]res://Assets/Icons/Ice.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			await moveCamAction("single")
			await cardBuff(raw, status, addrScen, "good")
			
		"Growth":
			#Growth I
			raw = 1.5
			nameSpell = "Growth"
			status = "earth"
			addrScen = "[center]+50% to Next [img width=12]res://Assets/Icons/Earth.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			await moveCamAction("single")
			await cardBuff(raw, status, addrScen, "good")
		"Chill":
			#Chill I
			raw = 0.75
			status = "universal"
			addrScen = "[center]-25% to Next [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			await moveCamAction("single")
			await cardBuff(raw, status, addrScen, "bad")
			
		"Stun":
			#Stun I
			await moveCamAction("single")
			var res = await cardSingleTarget(active_card.damage_init, active_card.accuracy, active_card.mp_cost, "lightning", "res://Scenes/Effects/lightning.tscn", Vector2(0,58))
			if res[0] == true:
				print("stun")
				await cardStun(1)
		"Ultima":
			#Ultima (This is how we used to this)
			damage = 9999
			accuracy = 100
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Ultima"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/ultima.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("00ffc9"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("00a31e"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
					hand_enchants.pop_at(card_select)
					hand_enchants.push_back("")
			else:
				damage = 0
				text_instance.get_node("Text").text = "Miss"
				combatants[target].velocity.x = 700
			await instance.display_damage
			combatants[target].take_damage(damage)
			combatants[target].add_child(text_instance)
			await instance.anim_done
			if combatants[target].is_dead == true:
				combatants.pop_at(target)
				initiative.pop_at(target)
				print(combatants)
	await get_tree().create_timer(1.0).timeout
	for c in combatants:
		await c.enable_bars()
	for card in hand_ui:
		card.queue_free()
	hand_ui.clear()
	for card in alt_hand_ui:
		card.queue_free()
	alt_hand_ui.clear()
	possible_targets.clear()
	#$Camera2D/CText.text = ""
	#pass_ui.visible = false
	target = -1
	card_select = -1
	action_id = ""
	initiative[curr_turn] = 100 - combatants[curr_turn].SPD
	init_ui.get_child(curr_turn).get_node("Init_Bar").value = 0
	next_turn()
