'''
Base Class for all Character Entities
'''
extends CharacterBody2D
@export var MaxHP: int
@onready var HP: int = MaxHP
@export var MaxMP: int = 1
var MP: int = 0
@export var SPD: int = 0
@export var move_speed: float = 100.0
var direction = 'up'
var movement = 0
var combat_spot = Vector2(0,0)
var in_combat : bool = false
var in_position: bool = false
var is_stun: bool = false
var is_dead: bool = false
signal damage
@onready var status_ui = $"StatusEffects"

var status_effects: Array = []

'''
Not sure if we want to use these

@export var fire_in: float = 1.0
@export var ice_in: float = 1.0
@export var lightning_in: float = 1.0
@export var earth_in: float = 1.0
@export var light_in: float = 1.0
@export var void_in: float = 1.0
'''


func _ready():
	if PlayerData.player_start_position != Vector2.ZERO:
		position = PlayerData.player_start_position


func _process(delta):
	if in_combat == true:
		$HP_Bar.max_value = MaxHP
		$"HP_Bar".value = HP
		$"MP_Bar".max_value = MaxMP
		$"MP_Bar".value = MP
		$"MP_Text".text = str(MP)
		$"HP_Text".text = str(HP)
		for s in status_ui.get_children():
			s.texture = null
		for i in range(min(8,len(status_effects))):
			match status_effects[i].element:
				"fire":
					match status_effects[i].icon:
						"good":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Fire_Good.png")
						"bad":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Fire_Bad.png")
						"dot":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Fire_OT.png")
				"lightning":
					match status_effects[i].icon:
						"good":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Lightning_Good.png")
						"bad":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Lightning_Bad.png")
						"dot":
							pass
				"ice":
					match status_effects[i].icon:
						"good":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Ice_Good.png")
						"bad":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Ice_Bad.png")
						"dot":
							pass
				"earth":
					match status_effects[i].icon:
						"good":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Earth_Good.png")
						"bad":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Earth_Bad.png")
						"dot":
							pass
				"universal":
					match status_effects[i].icon:
						"good":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Attack_Good.png")
						"bad":
							status_ui.get_child(i).texture = load("res://Assets/Icons/Attack_Bad.png")
						"dot":
							pass
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
	$StatusEffects.visible = true
	
func disable_bars():
	$HP_Bar.visible = false
	$HP_Text.visible = false
	$MP_Bar.visible = false
	$MP_Text.visible = false
	$StatusEffects.visible = false

func move_character(spot: Vector2):
	combat_spot = spot
	in_position = false

func atk_status(dmg: float, element: String):
	var counter = 0
	while counter < len(status_effects):
		if status_effects[counter].proc_id == 1 and (status_effects[counter].element == element or status_effects[counter].element == "universal"):
			dmg = status_effects[counter].proc_effect(dmg)
			if status_effects[counter].rounds < 0:
				status_effects.pop_at(counter)
			else:
				counter += 1
		else:
			counter += 1
	return dmg
	
func run_status():
	var counter = 0
	while counter < len(status_effects):
		if status_effects[counter].proc_id == 0:
			status_effects[counter].proc_effect(self)
			if status_effects[counter].rounds == 0:
				status_effects.pop_at(counter)
			else:
				counter += 1
		else:
			counter += 1

func take_damage(dmg: int):
	if dmg == 0:
		return
	$AnimatedSprite2D.play("hurt")
	HP -= dmg
	if HP <= 0:
		HP = 0
		death()
	else:
		await get_tree().create_timer(.5).timeout
		$AnimatedSprite2D.play("idle_side")
	
func death():
	$AnimatedSprite2D.play("death")
	is_dead = true
