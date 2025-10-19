extends CharacterBody2D

@export var SPEED = 50
@export var direction = Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bt_player: BTPlayer = $BTPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var collider: CollisionShape2D = $InfectionArea/Collider

var infected_color = Color("ff061b", 0.8)
var health_color = Color("6cf949")

enum Enemy_State {
	INFECTED,
	HEALTHY
}

var current_state = Enemy_State.HEALTHY
var health = 100
var infection_rate = 10
var immunity = 5
var infected = true
var infection_radius = 12

var active_skin = null

func _ready() -> void:
	randomize()
	
	var skin_index = randi() % 5
	active_skin = get_node("visual_"+ str(skin_index))
	active_skin.visible=true 
	collider.shape.radius = infection_radius
	infect()
	
	
	

func _physics_process(delta: float) -> void:
	#velocity = direction * SPEED * delta
	#
	#move_and_collide(velocity)
	var currentLocation =  global_position
	var nextLocation = navigation_agent_2d.get_next_path_position()
	var newVelocity = (nextLocation - currentLocation).normalized() * SPEED 
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(newVelocity)
	else:
		_on_navigation_agent_2d_velocity_computed(newVelocity)
		
		
func _process(delta: float) -> void:
	animate()
	

func animate():
	if velocity.y < 0:
		active_skin.play("up")
	elif velocity.x < 0:
		active_skin.play("left")
	elif velocity.x > 0:
		active_skin.play("right")
	elif velocity.y > 0:
		active_skin.play("down")
	else:
		active_skin.play("idle")

func infect():
	# changes the enemy to be infected
	active_skin.modulate = infected_color
	current_state = Enemy_State.INFECTED
	infected = true
	
func damage(damage):
	var tween = create_tween()
	
	tween.tween_property(active_skin, "modulate", Color(1,1,1), 0.1)
	tween.tween_callback(infect)
	
	health -= damage
	if health <= 0:
		die()

func die():
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.5) # Fade out over 0.5 seconds
	fade_tween.tween_callback(queue_free)
	
func move(position: Vector2):
	navigation_agent_2d.target_position = position
	
## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()


func _on_navigation_agent_2d_navigation_finished() -> void:
	#print("Finished navigation")
	pass

func _on_infection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage(infection_rate)
