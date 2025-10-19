extends  Node
# In your spawner script
@onready var spawn_timer = $Timer
@export var object_scene: PackedScene
@export var target: CharacterBody2D
@export var wait_time: int = 2
@export var max_entities = 1
@export var entity_group = ""


func _ready():
	spawn_timer.wait_time = wait_time
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
func random_spawn_point(margin):
	randomize() # Initialize the random number generator
	var spawn_pos = Vector2()

	spawn_pos.x = randf_range(-50, 1600)
	spawn_pos.y = randf_range(-130, 1200)

	return spawn_pos
	
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_tree().root.get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()
	

func _on_spawn_timer_timeout():
	var enemies =  get_tree().get_nodes_in_group(entity_group)
	if enemies.size() >= max_entities:
		return
	
	if not target:
		return

	var obj = object_scene.instantiate() # Create a new instance of the object scene	
	
	var spawn_point: Vector2
	var is_good_position: bool = false
	while not is_good_position:
		spawn_point = random_spawn_point(0)
		is_good_position = is_good_position(spawn_point)
	
	obj.global_position = spawn_point
	
	add_child(obj) # Add the object to the scene
	
	
		
	
