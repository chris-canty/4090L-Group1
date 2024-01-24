extends "res://Scripts/character.gd"

func _ready():
	pass

func _physics_process(delta):
	pass


func _on_hitbox_entered(body):
	if body.has_method("player") and is_dead == false:
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = true
		get_parent().initiate_combat()


func _on_animated_sprite_2d_animation_finished():
	if is_dead == true:
		queue_free()
