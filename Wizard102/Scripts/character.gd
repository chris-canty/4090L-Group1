'''
Base Class for all Character Entities
'''
extends CharacterBody2D
@export var MaxHP: int = 10
var HP: int = MaxHP
@export var MaxMP: int = 1
var MP: int = 0
@export var SPD: int = 0
@export var move_speed: float = 100.0
var direction = 'up'
var movement = 0
var combat_spot = Vector2(0,0)
var in_combat = false
var in_position = false

func _ready():
	HP = MaxHP

func _process(delta):
	if in_combat == true:
		$HP_Bar.max_value = MaxHP
		$"HP_Bar".value = HP
		$"MP_Bar".max_value = MaxMP
		$"MP_Bar".value = MP
		$"MP_Text".text = str(MP)
		$"HP_Text".text = str(HP)
		if in_position == false:
			var speed: float = 5 #set this to whatever you want, 5ish is a good start
			position.x = lerp(position.x,combat_spot.x,speed * delta)
			position.y = lerp(position.y,combat_spot.y,speed * delta)
			if position.x >= (combat_spot.x - 2) and position.x <= (combat_spot.x + 2) and position.y >= (combat_spot.y - 2) and position.y <= (combat_spot.y + 2):
				in_position = true
	else:
		var anim = $AnimatedSprite2D
		if direction == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("move_side")
			else:
				anim.play("idle_side")
		elif direction == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("move_side")
			else:
				anim.play("idle_side")
		elif direction == "up":
			if movement == 1:
				anim.play("move_up")
			else:
				anim.play("idle_up")
		else:
			if movement == 1:
				anim.play("move_down")
			else:
				anim.play("idle_down")

func enable_bars():
	$HP_Bar.visible = true
	$HP_Text.visible = true
	$MP_Bar.visible = true
	$MP_Text.visible = true
	
func disable_bars():
	$HP_Bar.visible = false
	$HP_Text.visible = false
	$MP_Bar.visible = false
	$MP_Text.visible = false

func move_character(spot: Vector2):
	combat_spot = spot
	in_position = false
