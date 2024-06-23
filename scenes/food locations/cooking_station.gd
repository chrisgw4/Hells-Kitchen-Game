extends StaticBody2D
class_name CookingStation

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

@export var node_holding_item:Node2D

## The timer lets the grill cook items after a certain time of them being on the grill
@export var timer:Timer

@export var progress_bar:TextureProgressBar

@export var sprite_frame:int = 0

@export var animated_sprite:AnimatedSprite2D

@export var animation_name:String
@export var animation_player:AnimationPlayer


func _update_progress_bar() -> void:
	progress_bar.value = timer.wait_time - timer.time_left

func _physics_process(delta):
	_update_progress_bar()

# The current item that is on the grill
var item:Item:
	set(new_item):
		item = new_item
		

# The player of the game
var player:Player = null

func _ready() -> void:
	interaction_component.player_entered.connect(_player_entered)
	interaction_component.player_exited.connect(_player_exited)
	progress_bar.max_value = timer.wait_time
	animated_sprite.frame = sprite_frame
	
	if animation_name:
		animation_player.play(animation_name)
	#$AnimationPlayer.play("glow")
	


func _player_entered(body:Player):
	player = body
	

func _player_exited(body:Player):
	player = null
	

func _input(event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		if not item and player.carried_item and player.carried_item is CookableItem:
			item = player.carried_item # set the item to the player's carried item
			item.reparent(node_holding_item)
			item.global_position = node_holding_item.global_position
			player.carried_item = null
			
			start_grilling()
			item.z_index = 1
		elif item and player.carried_item == null:
			item.reparent(player.node_carrying_item)
			player.carried_item = item
			item.z_index = 0
			#item.global_position = player.node_carrying_item.global_position
			#player.carried_item = item # set the player's carried item to the current item
			item = null # set the new item to null
			stop_grilling()
			


func start_grilling() -> void:
	timer.start()
	progress_bar.show()
	progress_bar.value = 0
	set_physics_process(true)

func stop_grilling() -> void:
	timer.stop()
	progress_bar.hide()
	set_physics_process(false)


func _on_cook_timer_timeout():
	if item:
		item.cook()
		#if "is_grillable" in item:
			#item.grill()
		#elif "is_fryable" in item:
			#item.fry()
		if item.has_more_states():
			start_grilling()
		else:
			stop_grilling()
