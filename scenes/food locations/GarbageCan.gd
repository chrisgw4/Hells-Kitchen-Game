extends StaticBody2D
class_name GarbageCan

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

# The current item that is in the garbage
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
	

func _input(_event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		if not item and player.carried_item:
			item = player.carried_item # set the item to the player's carried item
			player.carried_item = null
			item.queue_free()
			item = null
	
