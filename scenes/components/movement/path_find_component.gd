extends Node2D
class_name PathfindComponent

## Add the Velocity Component of the scene to this to get the character to move
@export var velocity_component:VelocityComponent

@onready var nav_agent:NavigationAgent2D = $NavigationAgent2D

@onready var player = get_tree().current_scene.get_node_or_null("./Player")

@onready var timer:Timer = $PathfindTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	$NavigationAgent2D.connect("velocity_computed", _process)
	timer.start()
	pass # Replace with function body.





func set_target_position(target_pos:Vector2) -> void:
	# if the timer is already started keep going and dont change target position
	#if not timer.is_stopped():
		#return
	
	# starts the timer to find the path to target
	timer.start()
	
	# sets the target position of the nav agent
	nav_agent.target_position = target_pos

func force_set_target_position(target_pos:Vector2) -> void:
	nav_agent.target_position = target_pos
	timer.start()
	


func follow_path() -> void:
	# when the nav agent is done moving/ reached its target
	#if (nav_agent.is_navigation_finished()):
		## decelerate down to (0,0)
		#velocity_component.decelerate()
		#timer.stop()
		#return
	var dir:Vector2 = (nav_agent.get_next_path_position()-global_position).normalized()
	velocity_component.accelerate_in_direction(dir)
	#nav_agent.set_velocity_forced(velocity_component.Velocity)
	nav_agent.velocity = velocity_component.Velocity
	

func flee_path() -> void:
	if (nav_agent.is_navigation_finished()):
		# decelerate down to (0,0)
		velocity_component.decelerate()
		timer.stop()
		return
	
	var dir:Vector2 = (nav_agent.get_next_path_position()-global_position).normalized()
	velocity_component.accelerate_in_direction(-dir)
	#nav_agent.set_velocity_forced(velocity_component.Velocity)
	nav_agent.velocity = velocity_component.Velocity
	



# When called it will calculate the next step to go to player
func _on_pathfind_timer_timeout() -> void:
	if player:
		set_target_position(player.global_position)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	var newDirection:Vector2 = safe_velocity.normalized()
	#var currentDirection:Vector2 = velocity_component.Velocity.normalized();
	#velocity_component.accelerate_in_direction(newDirection)
	#print("DSKDHOHD")
