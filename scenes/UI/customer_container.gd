extends VFlowContainer
class_name CustomerContainer

@export var customer_scene:PackedScene = preload("res://scenes/UI/customer_order.tscn")

static var order_dict:Dictionary = {"Burger":preload("res://sprites/burger/burger_complete.png"), "Fries":preload("res://sprites/fries/fries_completed.png"), "Soda":preload("res://sprites/drink/drink_filled.png")}



func _add_customer(customer:Customer) -> void:
	var temp_customer_ui:CustomerOrder = customer_scene.instantiate()
	
	# Change the npc sprite to the sprite of the npc that was randomly chosen
	temp_customer_ui.npc_sprite.texture = customer.animated_sprite.sprite_frames.get_frame_texture("default", randi_range(0,2))
	temp_customer_ui.npc_sprite.scale = Vector2(0.75,0.75)
	
	print(customer.order)
	var temp:Texture2D = order_dict[customer.order]
	
	temp_customer_ui.order_sprite.texture = temp
	
	# link the customer ui and the real customer together
	#temp_customer_ui.customer_link = customer
	
	# When the customer is leaving the tree, free the ui element
	customer.order_completed.connect(temp_customer_ui.queue_free)
	
	add_child(temp_customer_ui)



