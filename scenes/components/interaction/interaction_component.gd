extends Area2D
class_name InteractionComponent


@export var collision_shape:CollisionShape2D

var player_inside:bool = false

signal player_entered(player)
signal player_exited(player)


func _on_body_entered(body):
	emit_signal("player_entered", body)



func _on_body_exited(body):
	emit_signal("player_exited", body)

