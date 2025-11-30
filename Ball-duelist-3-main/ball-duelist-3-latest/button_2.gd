extends Button

func _ready() -> void:
	# Connect the button's pressed signal
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	var maps = ["res://map1.tscn", "res://map2.tscn"]
	var chosen_map = maps[randi() % maps.size()]

	print("Loading: ", chosen_map)

	# Load the chosen map scene
	get_tree().change_scene_to_file(chosen_map)
