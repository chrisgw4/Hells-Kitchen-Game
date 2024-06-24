extends Node2D

@export var timer:Timer

@export var time_to_spawn:float = 1.0

@export var customer_container:CustomerContainer

@export var delivery_counters:Array[DeliveryCounter] = []

@export var hell_slider:Control

var customers:Array[Customer] = []

func play_intro() -> void:
	$CanvasLayer.play_intro()
	post_intro()

func post_intro() -> void:
	set_process(true)
	$SpawnTimer.start()
	$GameTimer.start()
	$Music.play()

func _ready() -> void:
	randomize()
	set_process(false)
	
	#spawn_customer()
	for counter:DeliveryCounter in delivery_counters:
		counter.plate_delivered.connect(_check_delivery)
	
	play_intro()
	sold_item.connect($Player.add_sold_data)


func _process(_delta):
	#$CanvasLayer/RichTextLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	#$CanvasLayer/RichTextLabel.text += "\n"
	$CanvasLayer/RichTextLabel.text = str(int($GameTimer.time_left)/60) + ":"
	if int($GameTimer.time_left)%60 < 10:
		$CanvasLayer/RichTextLabel.text += "0" + str(int($GameTimer.time_left)%60)
	else:
		$CanvasLayer/RichTextLabel.text += str(int($GameTimer.time_left)%60)


signal sold_item(item_name:String, base_points:int, bonus_points:int, bonus_type:int)

# Checks to see if the delivered plate is correct and valid
func _check_delivery(plate:Plate) -> void:
	if plate == null:
		return
	
	# If the plate doesnt have a completed meal
	if not plate.completed_plate:
		return
	
	for customer:Customer in customers:
		if plate.items != [] and plate.items[0].item_name == customer.order and not plate.delivered:
			$BellRing.play()
			plate.delivered = true
			
			# free the plate
			plate.call_deferred("queue_free")
			# free the customer
			customer.queue_free()
			customers.erase(customer)
			
			customer.order_completed.emit()
			
			
			
			if plate.items[0].item_name == "Burger":
				$Player.number_burger += 1
				$Player.points += 15
				# Best tier
				if customer.tier == 2:
					$Player.points += 10
					emit_signal("sold_item", plate.items[0].item_name, 15, 10, 2)
				elif customer.tier == 1:
					$Player.points += 5
					emit_signal("sold_item", plate.items[0].item_name, 15, 5, 1)
				else:
					$Player.points += 1
					emit_signal("sold_item", plate.items[0].item_name, 15, 1, 0)
			elif plate.items[0].item_name == "Fries":
				$Player.number_fries += 1
				$Player.points += 7
				# Best tier
				if customer.tier == 2:
					$Player.points += 6
					emit_signal("sold_item", plate.items[0].item_name, 7, 6, 2)
				elif customer.tier == 1:
					$Player.points += 4
					emit_signal("sold_item", plate.items[0].item_name, 7, 4, 1)
				else:
					$Player.points += 1
					emit_signal("sold_item", plate.items[0].item_name, 7, 1, 0)
			elif plate.items[0].item_name == "Soda":
				$Player.number_soda += 1
				$Player.points += 3
				# Best tier
				if customer.tier == 2:
					$Player.points += 4
					emit_signal("sold_item", plate.items[0].item_name, 3, 4, 2)
				elif customer.tier == 1:
					$Player.points += 2
					emit_signal("sold_item", plate.items[0].item_name, 3, 2, 1)
				else:
					$Player.points += 1
					emit_signal("sold_item", plate.items[0].item_name, 3, 1, 0)
			plate.items = []
			# decrement the number of customers
			number_of_customers -= 1
			hell_slider._update_value($Player.points)
			return
	

var number_of_customers:int = 0:
	set(new_val):
		# If there should be three customers at a time
		if number_of_one_customers == 0 and number_of_two_customers == 0 and new_val < 3:
			timer.start(randf_range(time_to_spawn, time_to_spawn * 7.5))
		# If there should be two customers on stage at a time
		elif number_of_one_customers == 0 and number_of_two_customers > 0 and new_val < 2:
			timer.start(randf_range(time_to_spawn, time_to_spawn * 5.5))
			number_of_two_customers -= 1
			pass
		# If there should only be one customer on stage now
		elif number_of_one_customers > 0 and new_val < 1:
			timer.start(randf_range(time_to_spawn, time_to_spawn * 2.5))
			number_of_one_customers -= 1
			#spawn_customer()
			pass
		
		
		
		number_of_customers = new_val

# The number of times at the beginning that you will only have one customer at a time
var number_of_one_customers:int = 3

# The number of times at the beginning that you will have two customers at a time
var number_of_two_customers:int = 2

# Spawns a customer and adds it to the UI
func spawn_customer() -> void:
	var temp_customer = load("res://scenes/customers/customer.tscn").instantiate()
	customers.append(temp_customer)
	customer_container._add_customer(temp_customer)
	number_of_customers += 1
	$DemonOrder.play()

func _on_spawn_timer_timeout():
	spawn_customer()


func _on_music_finished():
	$Music.play()


func _on_game_timer_timeout():
	$CanvasLayer._show_scores()
