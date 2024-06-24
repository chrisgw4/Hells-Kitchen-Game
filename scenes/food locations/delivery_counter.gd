extends Counter
class_name DeliveryCounter

signal plate_delivered(plate:Item)

func _ready() -> void:
	super._ready()
	interaction_component.player_entered.connect(_animate_shine)
	interaction_component.player_exited.connect(_stop_shine)


func _animate_shine(_body):
	$AnimationPlayer.play("shimmer")

func _stop_shine(_body):
	$AnimationPlayer.play("RESET")

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("interact_item") and player and can_place_plates_on and player.can_player_place:
		
		
		# if the grill does not have an item at the moment
		if not item and player.carried_item is Plate:
			item = player.carried_item # set the item to the player's carried item
			player.carried_item = null
			item.reparent(node_holding_item)
			item.global_position = node_holding_item.global_position
			item.z_index = 1
			item.connect("plate_updated", _signal_plate_delivered)
			item.connect("delivered_complete", _remove_item)
			
			emit_signal("plate_delivered", item)
			get_viewport().set_input_as_handled()
			
			
		elif item and player.carried_item == null:
			player.carried_item = item # set the player's carried item to the current item
			player.carried_item.z_index = 0
			item.disconnect("plate_updated", _signal_plate_delivered)
			item.disconnect("delivered_complete", _remove_item)
			
			#item.reparent(player.node_carrying_item)
			#item.global_position = player.node_carrying_item.global_position
			
			item = null # set the new item to null
			get_viewport().set_input_as_handled()
		
		elif player and item and player.carried_item and player.carried_item is Plate and can_place_plates_on:
			print('less real')
			var temp = player.carried_item
			player.carried_item = item
			item.reparent(player.node_carrying_item)
			item.z_index = 0
		
			item = temp
			temp.reparent(node_holding_item)
			temp.global_position = node_holding_item.global_position
			temp.z_index = 1
			
			# tell game that the plate was added again
			item.connect("plate_updated", _signal_plate_delivered)
			item.connect("delivered_complete", _remove_item)
			
			emit_signal("plate_delivered", item)
			get_viewport().set_input_as_handled()


func _signal_plate_delivered() -> void:
	emit_signal("plate_delivered", item)

func _remove_item() -> void:
	item = null
