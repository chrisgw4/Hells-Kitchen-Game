extends StaticBody2D
class_name DrinkDispensary

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

@export var node_holding_items:Node2D

@export var fill_timer:Timer

# The current item that is on the chopping block
var item:Item:
	set(new_item):
		item = new_item
		

# The player of the game
var player:Player = null


func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)
	interaction_component.player_entered.connect(_animate_shine)
	interaction_component.player_exited.connect(_stop_shine)


func _animate_shine(_body):
	$AnimationPlayer.play("shimmer")

func _stop_shine(_body):
	$AnimationPlayer.play("RESET")


func _player_entered(body:Player):
	player = body
	

func _player_exited(_body:Player):
	player = null



func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		if not item and player.carried_item and "filled" in player.carried_item and not player.carried_item.filled:
			item = player.carried_item # set the item to the player's carried item
			item.reparent(node_holding_items)
			item.global_position = node_holding_items.global_position
			item.z_index = 1
			player.carried_item = null
			if item is FillableItem:
				start_filling()
				#$AudioStreamPlayer2D.play()
				#item.fill()
		elif item and not player.carried_item and item.filled:
			item.z_index = 0
			player.carried_item = item
			item.reparent(player.node_carrying_item)
			item = null
			fill_timer.stop()
		elif item and player.carried_item and player.carried_item is FillableItem:
			var temp = player.carried_item
			
			player.carried_item = item
			item.reparent(player.node_carrying_item)
			item.z_index = 0
			
			item = temp
			item.reparent(node_holding_items)
			item.global_position = node_holding_items.global_position
			item.z_index = 1
			start_filling()
		elif item and player.carried_item and player.carried_item is Plate:
			if player.carried_item.check_add_item(item):
				player.carried_item.add_item(item)
				item = null
				$FillTimer.stop()
			
		get_viewport().set_input_as_handled()
	

func start_filling() -> void:
	fill_timer.start()
	$AudioStreamPlayer2D.play()


func _on_fill_timer_timeout():
	item.fill()
	$AudioStreamPlayer2D.stop()
