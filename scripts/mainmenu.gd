extends CanvasLayer

var game = preload("res://scenes/main.tscn")

func start():
	var game_instance = game.instantiate()
	get_tree().root.add_child(game_instance)
	queue_free()

func _on_button_pressed() -> void:
	start()
