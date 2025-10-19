extends Node2D
@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var player: CharacterBody2D = $Player
@onready var barrier_bar: ProgressBar = $Control/BarrierBar

var mainmenu = load("res://scenes/Mainmenu.tscn")

var player_timer: Timer
@onready var label: Label = $Control/Timer
var game_time = 0

func _ready() -> void:
	health_bar.init_bar(player.max_health)
	barrier_bar.init_bar(player.max_barrier)
	_set_player_timer()
	
func _process(delta: float) -> void:
	health_bar.update_bar(player.health)
	barrier_bar.update_bar(player.barrier)
	
	if player.health < 0:
		game_over()
		
func game_over():
	var instance = mainmenu.instantiate()
	get_tree().root.add_child(instance)
	queue_free()
	
func _set_player_timer() -> void:
	player_timer = Timer.new()
	player_timer.wait_time = 1.0  # Update every second
	player_timer.one_shot = false  # Make it repeat
	player_timer.timeout.connect(_on_player_timer_timeout)
	add_child(player_timer)
	player_timer.start()

func _on_player_timer_timeout() -> void:
	game_time += 1
	_update_player_timer_label()

func _update_player_timer_label() -> void:
	var minutes = game_time / 60
	var seconds = game_time % 60
	label.text = "%02d:%02d" % [minutes, seconds]
