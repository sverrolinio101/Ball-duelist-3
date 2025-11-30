extends Node2D  # Or Area2D if you want collisions

@export var enemy: NodePath         # Target player NodePath
@export var speed: float = 1000      # Movement speed
@export var life_time: float = 99.0  # Max time before auto-delete

var target_position: Vector2         # Where to go
var direction: Vector2               # Normalized movement direction

func _ready():
	if enemy == null or not has_node(enemy):
		print("ERROR: Invalid target")
		queue_free()
		return

	var target_node = get_node(enemy)
	target_position = target_node.global_position   # Lock the position at firing
	direction = (target_position - global_position).normalized()

	# Rotate to face the target
	look_at(target_position)

	# Auto-remove after lifetime
	await get_tree().create_timer(life_time).timeout
	queue_free()


func _process(delta):
	# Move straight toward the locked target position
	global_position += direction * speed * delta

	# Stop/delete when it reaches the position
	#if global_position.distance_to(target_position) < 10:
		#queue_free()
