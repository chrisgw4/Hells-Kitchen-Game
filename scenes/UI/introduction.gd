extends Control

@export var text_label:Label

var arr:Array[String] = ["Hello, welcome to hell. As you could’ve probably guessed, I’m Satan.", "Now now let’s see what we’ve got here…oh bugger it all another bloody chef!", "Well that’s good news for you at least. It means you’ve gotta chance of getting out of here.", "You see I’ve got a passion for fine dining and demons aren’t exactly 5 star chefs. That’s where muppets like you come in.", "You work your arse off the in kitchen and I may be inclined to let you go back to earth or if you really put in some effort, heaven.", "Now get to work you gormless nitwit! OR ELSE!"]
var current_index:int = 0
var stop_current_word:bool = false

func _ready():
	scroll_text(arr[current_index])
	current_index += 1


func scroll_text(input_text:String) -> void:
	stop_current_word = false
	text_label.visible_characters = 0
	
	text_label.text = input_text
	
	for i in input_text:
		if stop_current_word:
			return
		text_label.visible_characters = clamp(text_label.visible_characters+1, 0, len(text_label.text))
		await get_tree().create_timer(0.1).timeout

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if text_label.visible_characters != len(text_label.text):
				stop_current_word = true
				text_label.visible_characters = len(text_label.text)
			elif current_index < len(arr):
				scroll_text(arr[current_index])
				current_index+=1
			elif current_index >= len(arr):
				get_tree().paused = false
				get_parent().is_intro_done = true
				queue_free()
		
