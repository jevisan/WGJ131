extends CanvasLayer

var player
var p_state_machine

func _ready():
	p_state_machine = get_node("../PlayerStateMachine")
	
func _process(delta):
	$Health.text = "Health: " + str(get_parent().health)
	$State.text = "State: " + p_state_machine.get_current_state()