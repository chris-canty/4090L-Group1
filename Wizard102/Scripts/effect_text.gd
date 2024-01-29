extends CharacterBody2D
var speed = -400
var decay = 50

func _ready():
	velocity.y = speed
	if $Text.text != "Miss":
		$boost.play()

func _physics_process(_delta):
	velocity.y += decay
	if velocity.y > 0:
		velocity.y = 0
	move_and_slide()

func _on_timer_timeout():
	queue_free()
