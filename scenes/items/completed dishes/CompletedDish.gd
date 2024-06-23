extends Item
class_name CompletedDish

## Animated Sprite
@export var animated_sprite:AnimatedSprite2D

## Class Names of the ingredients
@export var ingredients:Array[String]

func _ready():
	ingredients.sort()
