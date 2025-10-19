#*
#* arrive_pos.gd
#* =============================================================================
#* Copyright (c) 2023-present Serhii Snitsaruk and the LimboAI contributors.
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
@tool
extends BTAction
## Moves the agent to the specified position, favoring horizontal movement. [br]
## Returns [code]SUCCESS[/code] when close to the target position (see [member tolerance]);
## otherwise returns [code]RUNNING[/code].

## Blackboard variable that stores the target position (Vector2)
@export var target_position_var := &"pos"

## Variable that stores desired speed (float)
#@export var speed_var := &"speed"

## How close should the agent be to the target position to return SUCCESS.
@export var tolerance := 50.0



func _generate_name() -> String:
	return "Arrive  pos: %s" % [
		LimboUtility.decorate_var(target_position_var),
	]


func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_position_var, Vector2.ZERO)
	if target_pos.distance_to(agent.global_position) < tolerance:
		return SUCCESS

	agent.move(target_pos)
	#var speed: float = blackboard.get_var(speed_var, 10.0)
	#var dist: float = absf(agent.global_position.x - target_pos.x)
	#var dir: Vector2 = agent.global_position.direction_to(target_pos)
#
	## Prefer horizontal movement:
	#var vertical_factor: float = remap(dist, 200.0, 500.0, 1.0, 0.0)
	#vertical_factor = clampf(vertical_factor, 0.0, 1.0)
	#dir.y *= vertical_factor


	#var desired_velocity: Vector2 = dir.normalized() * speed
	#agent.move(dir)
	#agent.update_facing()
	return RUNNING
