extends CharacterBody2D
class_name Player

## The velocity component that allows the player to move
@export var vel_component:VelocityComponent

## The node that will be the parent of the carried item
@export var node_carrying_item:Node2D

@export var animated_sprite:AnimatedSprite2D

# Signal used for cancelling process of chopping or other use
signal stop_using_cooking_station()

signal show_interact_key()

var player_using_station:bool = false

var player_place_cooldown:float = 0.25

var can_player_place:bool = true

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



func start_using_station() -> void:
	player_using_station = true

func stop_using_station() -> void:
	player_using_station = false


func get_input() -> void:
	var dir:Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	# if the player clicks and key the user will stop doing whatever cooking process it was locked in
	if dir != Vector2.ZERO and player_using_station:
		stop_using_cooking_station.emit()
		player_using_station = false
	
	vel_component.accelerate_in_direction(dir)
	
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false
