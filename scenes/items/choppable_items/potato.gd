extends ChoppableItem
class_name Potato

var potato_fries:PackedScene = preload("res://scenes/items/cookable_items/fries.tscn")


func chop() -> void:
	chopped = true
	animated_sprite.frame = 1
	
