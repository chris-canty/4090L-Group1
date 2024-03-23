extends "res://Scripts/Status Effects/status.gd"

func proc_effect(user: CharacterBody2D):
	user.is_stun = true
	var scene = load("res://Scenes/UI/damage.tscn")
	var instance = scene.instantiate()
	instance.get_node("Text").text = "STUNNED!!"
	user.add_child(instance)
	rounds -= 1
