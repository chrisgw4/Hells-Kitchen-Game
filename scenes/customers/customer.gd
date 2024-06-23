extends Node2D
class_name Customer

var order:String

@export var animated_sprite:AnimatedSprite2D

static var chooseable_items:Array[String] = ["Burger", "Fries", "Soda"]

func _ready() -> void:
	order = chooseable_items.pick_random()
	animated_sprite.frame = randi_range(0,2)
