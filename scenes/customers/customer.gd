extends Node2D
class_name Customer

var tier:int = 2

@export var animated_sprite:AnimatedSprite2D

signal order_completed

static var chooseable_items:Array[String] = ["Burger", "Fries", "Soda"]

var order:String = chooseable_items.pick_random()

func _ready() -> void:
	#order = chooseable_items.pick_random()
	animated_sprite.frame = randi_range(0,2)


func _on_tree_exiting():
	pass # Replace with function body.


func _on_perfect_tier_timer_timeout():
	tier -= 1
	$MediumTierTimer.start()


func _on_medium_tier_timer_timeout():
	tier -= 1
