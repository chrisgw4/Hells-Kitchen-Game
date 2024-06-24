extends Control


static var dict:Dictionary = {"Burger":preload("res://sprites/burger/burger_complete.png"), "Fries":preload("res://sprites/fries/fries_completed.png"), "Soda":preload("res://sprites/drink/drink_filled.png")}


func _ready() -> void:
	pass

func set_up(data:SellData):
	$ColorRect/Sprite2D.texture = dict[data.item_name]
	$ColorRect2/Points.text += "" + str(data.base_points)
	$ColorRect3/BonusType.text += "" + str(data.bonus)
	
