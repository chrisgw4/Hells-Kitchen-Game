extends Item
class_name CookableItem

@export var animated_sprite:AnimatedSprite2D

@export_range(0,10) var total_cook_states:int

# The cook state of the item (0-total_cook_states) inclusive
var cook_state = 0:
	set(new_val):
		cook_state = clamp(new_val, 0, total_cook_states)
		animated_sprite.frame = cook_state


func cook() -> void:
	cook_state += 1

# returns true/false whether the item has more cook states
func has_more_states() -> bool:
	return cook_state < total_cook_states
