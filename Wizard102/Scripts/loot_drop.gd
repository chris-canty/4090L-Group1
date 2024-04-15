extends Node2D

var inPickArea= false
var item_added = false
var itemToPick = preload("res://Scenes/Characters/loot_drop.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var deck = PlayerData.deck
	if inPickArea:
		if Input.is_action_just_pressed("e"):
			var randomLoot = ["Bolt", "Frost", "Stone", "Blast", "Dark", "Ray", "Quake", "Chill", "Stun"]
			var randomInt = randi( )% len(randomLoot)
			var chosenLoot = randomLoot[randomInt]

			for items in deck:
				print(items)
			deck.append(chosenLoot)
			# Animation for card opening
			$AnimatedSprite2D.play("opened")
			
			# Wait for animation to finish then emit signal and cleanup
			await get_tree().create_timer(0.6).timeout
			$AnimatedSprite2D.play("open")
			
			# Load the corresponding scene for the chosen loot card
			var load_str = "res://Scenes/Cards/" + chosenLoot + "_card.tscn"
			var scene = load(load_str)
			var lootInstance = scene.instantiate()
			add_child(lootInstance)  # Ensure this is called before setting position if using global_position
			# Set position and add to the scene tree
			# Assuming lootInstance is a Node2D and $AnimatedSprite2D is its intended reference point
			lootInstance.position = $AnimatedSprite2D.position  # Use local position relative to the parent if same parent
			lootInstance.global_position.y -= 50  # Adjust position down by 5 units on y-axis
			lootInstance.global_position.x -= 15  # Adjust position down by 5 units on y-axis
			


			await get_tree().create_timer(2.0).timeout
			queue_free()  # Ensure this is safe to call here, might need repositioning based on context
			
			


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		inPickArea = true


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		inPickArea = false
