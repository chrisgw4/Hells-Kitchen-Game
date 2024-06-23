extends Node2D

@export var timer:Timer

@export var time_to_spawn:float = 1.0

var customers:Array[Customer] = []

func _ready() -> void:
	randomize()

func _process(delta):
	$CanvasLayer/RichTextLabel.text = "FPS: " + str(Engine.get_frames_per_second())


var number_of_customers:int = 0:
	set(new_val):
		pass

# The number of times at the beginning that you will only have one customer at a time
var number_of_one_customers:int = 3

# The number of times at the beginning that you will have two customers at a time
var number_of_two_customers:int = 2


func spawn_customer() -> void:
	var temp_customer = load("res://scenes/customers/customer.tscn").instantiate()
	customers.append(temp_customer)

func _on_spawn_timer_timeout():
	pass # Replace with function body.
