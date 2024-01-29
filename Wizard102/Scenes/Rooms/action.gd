extends "res://Scripts/room.gd"


func execute_action():
	var scene
	var instance
	var text
	var text_instance
	var damage
	var accuracy
	var roll = rng.randi_range(1,100)
	print(roll)
	var mp_cost
	for t in possible_targets:
		t[1].queue_free()
	match action_id:
		0:
			for card in hand_ui:
				card.queue_free()
			hand_ui.clear()
			possible_targets.clear()
			pass_ui.visible = false
			for c in combatants:
				await c.enable_bars()
			next_turn()
			return
		1:
			#Ember I
			damage = combatants[curr_turn].atk_status(8,"fire")
			accuracy = 80
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Ember"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/fire.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("d5621f"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("ff0000"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
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
		2:
			#Bolt I
			damage = combatants[curr_turn].atk_status(10,"lightning")
			accuracy = 80
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Bolt"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/lightning.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position - Vector2(0,58)
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("c3d511"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("ef9926"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
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
		3:
			#Frost I
			damage = combatants[curr_turn].atk_status(7,"ice")
			accuracy = 90
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Frost"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/ice.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("00ffff"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("0000ff"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
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
		4:
			#Stone I
			damage = combatants[curr_turn].atk_status(12,"earth")
			accuracy = 90
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Stone"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/earth.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("6e5003"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("005000"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
			else:
				damage = 0
				text_instance.get_node("Text").text = "Miss"
				combatants[target].velocity.x = 700
			await instance.display_damage
			combatants[target].take_damage(damage)
			combatants[target].add_child(text_instance)
			await instance.anim_done
			if  combatants[target] == null or combatants[target].is_dead == true:
				combatants.pop_at(target)
				initiative.pop_at(target)
				print(combatants)
			await get_tree().create_timer(1.0).timeout
		8:
			#Burn I
			damage = combatants[curr_turn].atk_status(16,"fire")
			var init_damage: int = damage * .25
			var dot: int = damage - init_damage
			accuracy = 100
			mp_cost = 1
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Burn"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/fire.tscn")
			instance = scene.instantiate()
			instance.position = combatants[target].position
			add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/damage.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				combatants[curr_turn].MP -= mp_cost
				text_instance.get_node("Text").text = str(init_damage)
				text_instance.get_node("Text").set("theme_override_colors/font_color",Color("d5621f"))
				text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("ff0000"))
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
			else:
				init_damage = 0
				text_instance.get_node("Text").text = "Miss"
				combatants[target].velocity.x = 700
			await instance.display_damage
			combatants[target].take_damage(init_damage)
			combatants[target].add_child(text_instance)
			await instance.anim_done
			if roll <= accuracy:
				var effect = load("res://Scenes/UI/effect.tscn")
				var effect_instance = effect.instantiate()
				var dot_effect = DoT.new()
				dot_effect.element = "fire"
				dot_effect.proc_id = 0
				dot_effect.rounds = 2
				dot_effect.damage_total = dot
				dot_effect.damage_remaining = dot
				combatants[target].status_effects.push_back(dot_effect)
				effect_instance.get_node("Text").text = "[center]" + str(dot) + " [img width=12]res://Assets/Icons/Fire.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img] 2 [img width=12]res://Assets/Icons/Rounds.png[/img][/center]"
				combatants[target].add_child(effect_instance)
			if  combatants[target] == null or combatants[target].is_dead == true:
				combatants.pop_at(target)
				initiative.pop_at(target)
				print(combatants)
			await get_tree().create_timer(1.0).timeout
		11:
			#Quake I
			damage = combatants[curr_turn].atk_status(10,"earth")
			accuracy = 75
			mp_cost = 2
			var dam_vals = []
			var damages = []
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Quake"
			cam_zoom = 5
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			scene = load("res://Scenes/Effects/earth.tscn")
			var hit = false
			for i in range(1,len(combatants)):
				instance = scene.instantiate()
				instance.position = combatants[i].position
				add_child(instance)
				#Damage Calculations
				text = load("res://Scenes/UI/damage.tscn")
				text_instance = text.instantiate()
				roll = rng.randi_range(1,100)
				print(roll)
				if roll <= accuracy:
					if hit == false:
						if _cState == Combat.P_Action:
							hand.pop_at(card_select)
						combatants[curr_turn].MP -= mp_cost
						hit = true
					text_instance.get_node("Text").text = str(damage)
					text_instance.get_node("Text").set("theme_override_colors/font_color",Color("6e5003"))
					text_instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("005000"))
					dam_vals.push_back(damage)
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
			var counter = 0
			while counter < len(combatants):
				if combatants[counter] == null or combatants[counter].is_dead == true:
					combatants.pop_at(counter)
					initiative.pop_at(counter)
				else:
					counter += 1
			print(combatants)
			await get_tree().create_timer(1.0).timeout
		15:
			#Heat Up I
			accuracy = 100
			mp_cost = 0
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Heat Up"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			#scene = load("res://Scenes/Effects/ice.tscn")
			#instance = scene.instantiate()
			#instance.position = combatants[target].position
			#add_child(instance)
			text = load("res://Scenes/UI/effect.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				var boost = Boost_ATK.new()
				boost.element = "fire"
				boost.proc_id = 1
				boost.rounds = -1
				boost.augment = 1.4
				combatants[target].status_effects.push_back(boost)
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
				text_instance.get_node("Text").text = "[center]+40% to Next [img width=12]res://Assets/Icons/Fire.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			else:
				text_instance.get_node("Text").text = "Miss"
			combatants[target].add_child(text_instance)
			#await instance.anim_done
			await get_tree().create_timer(1.0).timeout
		16:
			#Charge I
			accuracy = 100
			mp_cost = 0
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Charge"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			#scene = load("res://Scenes/Effects/ice.tscn")
			#instance = scene.instantiate()
			#instance.position = combatants[target].position
			#add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/effect.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				var boost = Boost_ATK.new()
				boost.element = "lightning"
				boost.proc_id = 1
				boost.rounds = -1
				boost.augment = 1.45
				combatants[target].status_effects.push_back(boost)
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
				text_instance.get_node("Text").text = "[center]+45% to Next [img width=12]res://Assets/Icons/Lightning.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			else:
				text_instance.get_node("Text").text = "Miss"
			combatants[target].add_child(text_instance)
			#await instance.anim_done
			await get_tree().create_timer(1.0).timeout
		17:
			#Cooldown I
			accuracy = 100
			mp_cost = 0
			for c in combatants:
				await c.disable_bars()
			$Camera2D/CText.text = "Cooldown"
			cam_zoom = 6
			cam_pos = combatants[target].position
			await get_tree().create_timer(1.0).timeout
			$Camera2D/CText.text = ""
			#scene = load("res://Scenes/Effects/ice.tscn")
			#instance = scene.instantiate()
			#instance.position = combatants[target].position
			#add_child(instance)
			#Damage Calculations
			text = load("res://Scenes/UI/effect.tscn")
			text_instance = text.instantiate()
			if roll <= accuracy:
				var boost = Boost_ATK.new()
				boost.element = "ice"
				boost.proc_id = 1
				boost.rounds = -1
				boost.augment = 1.35
				combatants[target].status_effects.push_back(boost)
				if _cState == Combat.P_Action:
					hand.pop_at(card_select)
				text_instance.get_node("Text").text = "[center]+35% to Next [img width=12]res://Assets/Icons/Ice.png[/img] [img width=12]res://Assets/Icons/Attack.png[/img][/center]"
			else:
				text_instance.get_node("Text").text = "Miss"
			combatants[target].add_child(text_instance)
			#await instance.anim_done
			await get_tree().create_timer(1.0).timeout
		99:
			#Ultima
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
	possible_targets.clear()
	#$Camera2D/CText.text = ""
	#pass_ui.visible = false
	target = -1
	card_select = -1
	action_id = 0
	next_turn()
