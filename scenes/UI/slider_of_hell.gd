extends Control

var value:int = 0
@export var time:float = .45

func _update_value(new_value:int) -> void:
	value = new_value
	var tween:Tween = create_tween()
	tween.tween_property($VSlider, "value", value, time)
	await tween.finished
	emit_signal("finished")
	

signal finished
