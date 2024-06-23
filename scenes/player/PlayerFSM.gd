extends FiniteStateMachine


func _init() -> void:
	_add_state("walk_side")
	_add_state("walk_up")
	_add_state("walk_down")
	_add_state("idle_down")
	_add_state("idle_side")
	_add_state("idle_up")


func _ready() -> void:
	set_state(states.walk_side)



func _state_logic(_delta: float) -> void:
	parent.get_input()

var dir:int = 0

func _get_transition() -> int:
	if abs(parent.velocity.x) > 20:
		dir = 0
		return states["walk_side"]
	
	if parent.velocity.y < -10:
		dir = 1
		return states["walk_up"]
	
	if parent.velocity.y > 10:
		dir = 2
		return states["walk_down"]
	
	if dir == 0:
		return states["idle_side"]
	elif dir == 1:
		return states["idle_up"]
	
	return states["idle_down"]


func _enter_state(_previous_state: int, new_state: int) -> void:
	animation_player.play(states_names[new_state])



