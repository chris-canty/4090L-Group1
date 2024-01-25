extends AnimatedSprite2D
@export var anim_time: float


# Called when the node enters the scene tree for the first time.
func _ready():
	$sound.play()
	play("default")
	await get_tree().create_timer(anim_time).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_finished():
	visible = false
