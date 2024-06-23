extends StaticBody2D
class_name DrinkDispensary

## The component that allows interaction with the player
@export var interaction_component:InteractionComponent

# The current item that is on the chopping block
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
	

func _player_exited(body:Player):
	player = null
	

func _input(event) -> void:
	if Input.is_action_just_pressed("interact_item") and player:
		# if the grill does not have an item at the moment
		if not item:
			item = player.carried_item # set the item to the player's carried item
			if item is DrinkCup:
				item.fill()
			item = null
		
		



