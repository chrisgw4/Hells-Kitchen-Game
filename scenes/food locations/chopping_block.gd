extends StaticBody2D
class_name ChoppingStation

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

## The node that will hold the item in the correct place
@export var node_holding_item:Node2D

## The timer lets the chopping block cook items after a certain time of them being on the chopping block
@export var timer:Timer

@export var progress_bar:TextureProgressBar

# The current item that is on the chopping block
var item:Item:
	set(new_item):
		item = new_item
		

# The player of the game
var player:Player = null


func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)
	progress_bar.max_value = timer.wait_time
	set_physics_process(false)


func _player_entered(body:Player):
	player = body
	
	# Check if the item exists, and it is not chopped, it will continue the chopping when you return to it
	if item and not item.chopped:
		start_chopping()
	#player.stop_using_cooking_station.connect(cancel_process)

func cancel_process() -> void:
	progress_bar.hide()
	timer.stop()
	set_physics_process(false)
	

func _player_exited(body:Player):
	#player.stop_using_cooking_station.disconnect(cancel_process)
	cancel_process()
	player = null

func _update_progress_bar() -> void:
	progress_bar.value = timer.wait_time - timer.time_left

func _physics_process(delta):
	_update_progress_bar()


func _input(event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		if not item and player.carried_item and player.carried_item is ChoppableItem and not player.carried_item.chopped:
			player.start_using_station()
			item = player.carried_item # set the item to the player's carried item
			player.carried_item = null
			item.reparent(node_holding_item)
			item.global_position = node_holding_item.global_position
			item.z_index = 1
			start_chopping() # start the timer
			
		elif item and not player.carried_item:
			item.reparent(player.node_carrying_item)
			#item.global_position = player.node_carrying_item.global_position
			player.carried_item = item # set the player's carried item to the current item
			item.z_index = 0
			item = null # set the new item to null
			timer.stop()
			progress_bar.hide()
			set_physics_process(false)


func start_chopping() -> void:
	timer.start()
	progress_bar.show()
	set_physics_process(true)


func _on_chop_timer_timeout():
	item.chop()
	progress_bar.hide()
