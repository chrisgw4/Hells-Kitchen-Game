extends Control


@export var slider_of_hell:Control
@export var rich_text:RichTextLabel
@export var text_label:Label

var hell:String = "Well that was sad to watch. Don’t worry though you’ll love it here. Hells a lot like a kitchen: hot, stressful, and things get stabbed with forks…"
var earth:String = "Welcome back home you muppet. Being honest you were a pretty good chef. It’s ok though, you’ll be back soon…"
var heaven:String = "Well I’ll be, you actually did it! Not often we get a chef who actually knows what they’re doing. Enjoy Heaven, you earned it."

static var sell_stats_scene:PackedScene = preload("res://scenes/UI/sell_stats.tscn")

#func _ready():
	#var player:Player = preload("res://scenes/player/player.tscn").instantiate()
	#player.sold_arr = []
	#for i in range(0, 20):
		#player.add_sold_data(["Burger", "Fries", "Soda"].pick_random(), 15, 1, [0,1,2].pick_random())
	#
	#player.points = 60
	#update_game_over(player)

func update_game_over(player:Player):
	$RichTextLabel3.text = str(player.points)
	$TotalFries.text = str(player.number_fries)
	$TotalBurgers.text = str(player.number_burger)
	$TotalSodas.text = str(player.number_soda)
	slider_of_hell._update_value(player.points)
	
	await slider_of_hell.finished
	if player.points < 90: # Still in hell
		scroll_text(hell)
	elif player.points < 370:
		scroll_text(earth)
	else:
		scroll_text(heaven)
	
	for i:SellData in player.sold_arr:
		var temp = sell_stats_scene.instantiate()
		temp.set_up(i)
		$ScrollContainer/VFlowContainer.add_child(temp)
		#$ScrollContainer.set_v_scroll(100)
		await get_tree().process_frame
		$ScrollContainer.ensure_control_visible(temp)
		if i.bonus == 2:
			$Bell.play()
		await get_tree().create_timer(1).timeout
		
		

func scroll_text(input_text:String) -> void:
	text_label.visible_characters = 0
	
	text_label.text = input_text
	
	for i in input_text:
		text_label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout
