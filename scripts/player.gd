extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var speed = 100
var knock_back_force = -10
var infection_raduis = 15
var infection_rate = 0

var max_health = 200
var health = max_health
var immunity = 5
var max_barrier = 100
var barrier = max_barrier
var barrier_regeneration = 1

	
func _process(delta: float) -> void:
	barrier += barrier_regeneration * delta
	

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	
	if input_dir == Vector2.UP:
		animated_sprite_2d.play("up")
	elif input_dir == Vector2.LEFT:
		animated_sprite_2d.play("left")
	elif input_dir == Vector2.RIGHT:
		animated_sprite_2d.play("right")
	elif input_dir == Vector2.DOWN:
		animated_sprite_2d.play("down")
	else:
		animated_sprite_2d.play("idle")
		

func _physics_process(delta):
	get_input()

	
	var collision = move_and_collide(velocity * delta)
	if collision:
		
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(collision.get_normal() * knock_back_force)

func default():
	# changes the enemy to be infected
	animated_sprite_2d.modulate = Color(1,1,1)

	
func damage(damage):
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color(1,0,0), 0.2)
	tween.tween_callback(default)
	
	if barrier > damage:
		barrier -= damage
		damage = 0
	else:
		damage -= barrier
	health -= damage
	
func collect(amount, type):
	if type == "Health":
		infection_rate = 0
		health = min(max_health, health + amount - infection_rate)
	else:
		barrier += amount


func _on_barrier_body_entered(body: Node2D) -> void:
	# damage the enemy
	if body.is_in_group("enemy"):
		var damage = barrier*0.2
		body.damage(damage*20)
		barrier -= damage
		
