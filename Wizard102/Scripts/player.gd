extends "res://Scripts/character.gd"

func _ready():
	if PlayerData.player_start_position != Vector2.ZERO:
		position = PlayerData.player_start_position
		PlayerData.player_start_position = Vector2.ZERO


func _physics_process(_delta):
	if in_combat == false and get_parent().isLoading == false:
		if Input.is_action_pressed('move_left'):
			direction = 'left'
			velocity.x = -move_speed
		elif Input.is_action_pressed("move_right"):
			direction = 'right'
			velocity.x = move_speed
		else:
			velocity.x = 0
		
		if Input.is_action_pressed("move_up"):
			velocity.y = -move_speed
			if velocity.x == 0:
				direction = 'up'
		elif Input.is_action_pressed("move_down"):
			velocity.y = move_speed
			if velocity.x == 0:
				direction = 'down'
		else:
			velocity.y = 0
		if (velocity.y != 0 || velocity.x != 0):
			movement = 1
		else:
			movement = 0
		move_and_slide()
	else:
		velocity.y = 0
		if velocity.x > 0:
			velocity.x -= 100
		elif velocity.x <= 0:
			velocity.x = 0
			in_position = false
		move_and_slide()

func player():
	pass


func _on_animated_sprite_2d_animation_finished():
	#if is_dead == true:
	#	queue_free()
	pass
