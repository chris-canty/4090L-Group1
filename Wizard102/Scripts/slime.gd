extends "res://Scripts/character.gd"
var rng = RandomNumberGenerator.new()


func _physics_process(delta):
	if in_combat == true:
		$AnimatedSprite2D.flip_h = true
		if velocity.x > 0:
			velocity.x -= 100
		elif velocity.x <= 0:
			velocity.x = 0
			in_position = false
		move_and_slide()


func _on_hitbox_entered(body):
	if body.has_method("player") and is_dead == false:
		$AnimatedSprite2D.play("idle_side")

		get_parent().initiate_combat()


func _on_animated_sprite_2d_animation_finished():
	if is_dead == true:
		queue_free()

func enemy_ai(combatants: Array):
	'''
	Slime Skills:
		Frost: 1 MP - 7 Ice Damage
		Cooldown: 0 MP - +35% Next Ice Attack
		Ultima: 6 MP - 9999 Arcane Damage
		
	Returns:
		[Skill ID, Target]
	'''
	match MP:
		0:
			return [0,self]
		6:
			return [99,combatants[0]]
		_:
			if status_effects.size() > 0:
				for s in status_effects:
					print(s)
					if s.element == "ice" and "augment" in s:
						if s.augment > 1:
							return [3,combatants[0]]
			if rng.randi_range(1,10) < 5:
				return [3,combatants[0]]
			elif rng.randi_range(1,10) < 8:
				while true:
					var target = rng.randi_range(0,len(combatants)-1)
					if combatants[target].is_in_group("Enemy"):
						return [17,combatants[target]]
			else:
				return [0,self]
