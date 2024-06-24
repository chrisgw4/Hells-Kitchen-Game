extends CharacterBody2D
class_name Player

## The velocity component that allows the player to move
@export var vel_component:VelocityComponent

## The node that will be the parent of the carried item
@export var node_carrying_item:Node2D

@export var animated_sprite:AnimatedSprite2D

var number_soda:int = 0
var number_burger:int = 0
var number_fries:int = 0

var sold_arr:Array[SellData] = []

func add_sold_data(item_name:String, base_points:int, bonus_points:int, bonus_type:int):
	var temp:SellData = SellData.new()
	temp.item_name = item_name
	temp.base_points = base_points
	temp.bonus_points = bonus_points
	temp.bonus = bonus_type
	sold_arr.append(temp)

# Signal used for cancelling process of chopping or other use
signal stop_using_cooking_station()

signal show_interact_key()

var in_range_of_object:bool = false:
	set(new_val):
		in_range_of_object = new_val
		

var player_place_cooldown:float = 0.25

var can_player_place:bool = true

var points:int = 0:
	set(new_val):
		points = new_val

func start_place_cool_down() -> void:
	can_player_place = false
	await get_tree().create_timer(player_place_cooldown).timeout
	can_player_place = true

# The item the player is currently holding
var carried_item:Item = null:
	set(new_item):
		if new_item != carried_item and new_item != null:
			new_item.reparent(node_carrying_item)
			new_item.global_position = node_carrying_item.global_position
		
		carried_item = new_item




func get_input() -> void:
	var dir:Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	
	vel_component.accelerate_in_direction(dir)
	
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false
