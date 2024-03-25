extends Node2D

var inPickArea= false
var itemToPick = preload("res://Scenes/Characters/loot_drop.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inPickArea:
		if Input.is_action_just_pressed("e"):
			#$AnimatedSprite2D.play("fade")
			queue_free()
			

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		inPickArea = true


func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		inPickArea = false
