extends Item
class_name ChoppableItem

@export var animated_sprite:AnimatedSprite2D

var chopped:bool = false

func chop() -> void:
	chopped = true
	animated_sprite.frame = 1
