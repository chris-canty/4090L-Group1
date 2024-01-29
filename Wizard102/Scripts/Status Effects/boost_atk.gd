extends "res://Scripts/Status Effects/status.gd"

var augment: float = 1.0

func proc_effect(dmg: int):
	return dmg * augment
