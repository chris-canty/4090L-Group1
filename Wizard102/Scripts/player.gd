extends "res://Scripts/character.gd"
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@export var deck: Array = []
func _physics_process(delta):
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
