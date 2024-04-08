extends "res://Scripts/Status Effects/status.gd"

var heal_total: int
var heal_remaining: int

func proc_effect(user: CharacterBody2D):
	var heal
	if rounds < 0:
		heal = heal_total
	else:
		heal = heal_remaining/rounds
	var scene = load("res://Scenes/UI/effect.tscn")
	var instance = scene.instantiate()
	instance.get_node("Text").text = str(heal)
	instance.get_node("Text").set("theme_override_colors/font_color",Color("00ff00"))
	instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("ff0000"))
	user.HP += heal
	if user.HP > user.MaxHP:
		user.HP = user.MaxHP 
	user.add_child(instance)
	if rounds > 0:
		rounds -= 1
		heal_remaining -= heal
