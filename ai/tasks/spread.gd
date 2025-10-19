@tool
extends BTAction
## Selects a random position nearby within the specified range and stores it on the blackboard. [br]
## Returns [code]SUCCESS[/code].

## Blackboard variable that holds current target (should be a Node2D instance).
@export var target_var: StringName = &"target"


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(target_var) as Node2D
	if not is_instance_valid(target):
		return FAILURE
	
	var direction = agent.global_position.direction_to(target.global_position)
	agent.move(direction)
	return SUCCESS
