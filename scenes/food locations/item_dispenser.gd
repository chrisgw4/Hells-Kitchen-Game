extends StaticBody2D
class_name ItemDispenser

## The type of item the dispenser will put out
@export var item_type:PackedScene

@export var interaction_component:InteractionComponent

# The current item that is able to be picked up
var item:Item

# The node that the item will be placed at
@export var node_holding_item:Node2D

# The player of the game
var player:Player = null


func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)
	make_item()


func _player_entered(body:Player):
	player = body
	

func _player_exited(body:Player):
	player = null

func make_item() -> void:
	item = item_type.instantiate()
	add_child(item)
	item.global_position = node_holding_item.global_position

func _input(event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		#if not item:
			#item = player.carried_item # set the item to the player's carried item
			#item.reparent(node_holding_item)
			#item.global_position = node_holding_item.global_position
		if item and player.carried_item == null:
			item.reparent(player.node_carrying_item)
			player.carried_item = item
			
			#item.global_position = player.node_carrying_item.global_position
			#player.carried_item = item # set the player's carried item to the current item
			item = null # set the new item to null
			make_item()
