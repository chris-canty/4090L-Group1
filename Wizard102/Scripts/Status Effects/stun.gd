extends "res://Scripts/Status Effects/status.gd"

func proc_effect(user: CharacterBody2D):
	user.is_stun = true
	rounds -= 1
