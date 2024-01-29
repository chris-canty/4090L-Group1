extends AnimatedSprite2D
@export var damage_delay: float
signal display_damage
signal anim_done
var init = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !init:
		init = true
		$sound.play()
		play("default")
		await get_tree().create_timer(damage_delay).timeout
		emit_signal("display_damage")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_finished():
	emit_signal("anim_done")
	queue_free()
