extends Node2D

@export var amount: int
@export_enum("Health", "Barrier") var type
@onready var surgical_mask: Sprite2D = $SurgicalMask
@onready var n_95: Sprite2D = $N95
@onready var health: Sprite2D = $Health
@onready var indicator: Sprite2D = $indicator

var active

func _ready() -> void:
	var visuals = [surgical_mask, n_95, health]
	var types = ["Barrier", "Barrier", "Health"]
	var amounts = [30, 50, 30]
	
	randomize()
	var index = randi() % 3
	active = visuals[index]
	active.visible = true
	type = types[index]
	amount = amounts[index]
	float_up()

func float_up():
	var tween = create_tween()
	tween.tween_property(self, "position" , position + Vector2(0,5), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(float_down)
	
func float_down():
	var tween = create_tween()
	tween.tween_property(self, "position" ,  position - Vector2(0,5), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(float_up)
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		# add a tween to animate the coin disappearing
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
		tween.tween_callback(queue_free)
		
		body.collect(amount, type)

		
func _process(delta):
	var g_pos = global_position
	var camera_rect: Rect2 = get_viewport_rect() * get_canvas_transform()
	
	if g_pos.x < camera_rect.position.x || g_pos.y < camera_rect.position.y || g_pos.x > (camera_rect.end.x) || g_pos.y > (camera_rect.end.y):
		#print("Off_screen")
		pass
		#$indicator.show()
		#var new_pos = $indicator.get_global_position()
		## clamping ensures indicator stays in visible area of screen
		## sort of a bonus that clamping also ensures indicator is as close to asteroid as possible while still being visible
		#new_pos.x = clamp(new_pos.x, camera_rect.position.x, camera_rect.end.x)
		#new_pos.y = clamp(new_pos.y, camera_rect.position.y, camera_rect.end.y)
		#$indicator.set_global_position(new_pos)
	else: 
		pass
		#print("On_screen")
		#$indicator.hide()
