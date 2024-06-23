extends Item
class_name DrinkCup

@export var animated_sprite:AnimatedSprite2D

# The cup has two states, if it is filled or if it is empty
var filled:bool = false

# The function sets the cup's state to filled
func fill() -> void:
	filled = true
