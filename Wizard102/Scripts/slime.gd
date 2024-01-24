extends "res://Scripts/character.gd"
var rng = RandomNumberGenerator.new()


func _physics_process(delta):
	if velocity.x > 0:
		velocity.x -= 100
	elif velocity.x <= 0:
		velocity.x = 0
		in_position = false
	move_and_slide()


func _on_hitbox_entered(body):
	if body.has_method("player") and is_dead == false:
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = true
		get_parent().initiate_combat()


func _on_animated_sprite_2d_animation_finished():
	if is_dead == true:
		queue_free()

func enemy_ai(combatants: Array):
	'''
	Slime Skills:
		Ember: 1 MP - 8 Fire Damage
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
			if rng.randi_range(0,100) < 75:
				return [1,combatants[0]]
			else:
				return [0,self]
