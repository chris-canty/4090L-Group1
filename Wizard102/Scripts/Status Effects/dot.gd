extends "res://Scripts/Status Effects/status.gd"

var damage_total: int
var damage_remaining: int

func proc_effect(user: CharacterBody2D):
	var damage = damage_remaining/rounds
	var scene = load("res://Scenes/UI/damage.tscn")
	var instance = scene.instantiate()
	instance.get_node("Text").text = str(damage)
	match element:
		"fire":
			instance.get_node("Text").set("theme_override_colors/font_color",Color("d5621f"))
			instance.get_node("Text").set("theme_override_colors/font_shadow_color",Color("ff0000"))
	user.take_damage(damage)
	user.add_child(instance)
	rounds -= 1
	damage_remaining -= damage
