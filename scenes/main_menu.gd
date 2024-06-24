extends Node2D


func _on_music_volume_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	print(value)


func _on_sfx_volume_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	print(value)


func _on_texture_button_pressed():
	$Button2.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_sfx_volume_drag_ended(_value_changed):
	
	$TestSFX.play()


func _on_button_mouse_entered():
	$HelpScreen.show()


func _on_button_mouse_exited():
	$HelpScreen.hide()


func _on_controls_mouse_entered():
	$ControlScreen.show()


func _on_controls_mouse_exited():
	$ControlScreen.hide()



func _on_gameplay_help_mouse_entered():
	$GameplayHelp2.show()


func _on_gameplay_help_mouse_exited():
	$GameplayHelp2.hide()
