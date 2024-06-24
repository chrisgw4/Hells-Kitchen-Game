@tool
extends StaticBody2D
class_name Counter


## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

@export var node_holding_item:Node2D

@export var animated_sprite:AnimatedSprite2D

@export var can_place_plates_on:bool = false

@export_range(0,3) var sprite_frame:int = 0:
	set(new_val):
		sprite_frame = new_val
		animated_sprite.frame = sprite_frame

# The current item that is on the grill
var item:Item:
	set(new_item):
		item = new_item
		

# The player of the game
var player:Player = null

func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)


func _player_entered(body:Player):
	player = body
	

func _player_exited(_body:Player):
	player = null
	

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("interact_item") and player and can_place_plates_on and player.can_player_place:
		print('real')
		# if the grill does not have an item at the moment
		if not item and player.carried_item is Plate:
			item = player.carried_item # set the item to the player's carried item
			player.carried_item = null
			item.reparent(node_holding_item)
			item.global_position = node_holding_item.global_position
			item.z_index = 1
			#get_viewport().set_input_as_handled()
			
		elif item and player.carried_item == null:
			player.carried_item = item # set the player's carried item to the current item
			#item.reparent(player.node_carrying_item)
			#item.global_position = player.node_carrying_item.global_position
			item.z_index = 0
			item = null # set the new item to null




