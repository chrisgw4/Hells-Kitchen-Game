extends Item
class_name FillableItem

@export var animated_sprite:AnimatedSprite2D

var filled:bool = false

func fill() -> void:
	filled = true
	animated_sprite.frame = 1
