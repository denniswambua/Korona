@tool
extends BTAction
## Selects a random position nearby within the specified range and stores it on the blackboard. [br]
## Returns [code]SUCCESS[/code].


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	agent.move(direction)
	return SUCCESS
