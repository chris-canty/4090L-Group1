extends "res://Scripts/character.gd"

func _ready():
	pass

func _physics_process(delta):
	pass


func _on_hitbox_entered(body):
	if body.has_method("player"):
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = true
		get_parent().initiate_combat()
