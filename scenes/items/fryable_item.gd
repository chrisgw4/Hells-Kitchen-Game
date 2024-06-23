extends Item
class_name FryableItem

@export var animated_sprite:AnimatedSprite2D

var is_fryable:bool = true

# The cook state of the item (0-2) inclusive
var cook_state = 0:
	set(new_val):
		cook_state = clamp(cook_state, 0, 2)
		animated_sprite.frame = cook_state


func fry() -> void:
	cook_state += 1

# returns true/false whether the item has more cook states
func has_more_states() -> bool:
	return cook_state < 2
