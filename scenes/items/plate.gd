extends Item
class_name Plate

# The items the plate is holding at the moment
var items:Array[Item] = []

static var recipes:Dictionary = {"Burger":preload("res://scenes/items/completed dishes/burger.tscn").instantiate().ingredients}

# Keeps track if the plate food is complete to stop adding items
var completed_plate:bool = false

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

@export var node_holding_items:Node2D

# The player of the game
var player:Player = null

func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)
	
	


func _player_entered(body:Player):
	player = body
	

func _player_exited(body:Player):
	player = null


func _input(event) -> void:
	if Input.is_action_just_pressed("interact_item") and player and not completed_plate:
		# if the plate does not have the item
		print("here")
		if player.carried_item and check_add_item(player.carried_item):#player.carried_item not in items:
			player.start_place_cool_down()
			items.append(player.carried_item)
			player.carried_item.reparent(node_holding_items)
			player.carried_item.global_position = node_holding_items.global_position + Vector2(0,-10)*len(items)
			player.carried_item = null
			_check_recipes()
		# if the player is not holding an item
		#elif not player.carried_item:
			#player.carried_item = self
			#reparent(player.node_carrying_item)
			#global_position = player.node_carrying_item.global_position
			

func _check_recipes() -> void:
	#print(items)
	#
	#print(check_add_item(load("res://scenes/items/lettuce.tscn").instantiate()))
	#
	
	if get_item_class_strings() == recipes["Burger"]:
		for i in node_holding_items.get_children():
			i.queue_free()
		print("has")
		items.clear() # clear the item array
		# Add the burger to the plate
		var burger = load("res://scenes/items/completed dishes/burger.tscn").instantiate()
		items.append(burger)
		node_holding_items.add_child(burger)
		
		completed_plate = true # set the plate to completed
		
		burger.global_position = node_holding_items.global_position + Vector2(0, -5)
		
		
		#print(burger)
	
	print(items)


# Returns an array of strings of the items in array
func get_item_class_strings() -> Array[String]:
	var arr:Array[String] = []
	for i in items:
		arr.append(i.item_name)
		
	arr.sort()
	return arr

# Need to test this
func check_add_item(item:Item) -> bool:
	# Checks each item
	for i in items:
		# See if the item is the same as the passed item
		if i.item_name == item.item_name:
			print("L")
			return false # false is returned as the item cannot be added
	
	var str_arr:Array[String] = get_item_class_strings()
	
	# go through each recipe
	for val in recipes:
		# if the str_arr is the same as the recipe array, and the item name is in the recipe array, and the item name is
		if str_arr == recipes[val] and item.item_name in recipes[val]:
			print("woah")
			return false
		if "cook_state" in item and item.cook_state != 1:
			print('failed')
			return false
		if "chopped" in item and not item.chopped:
			return false
	
	return true
