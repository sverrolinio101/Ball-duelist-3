extends Node2D  # Or Area2D if you want collisions

@export var enemy: NodePath
@export var speed: float = 220
@export var life_time: float = 99.0  # projectile expires after 3 seconds

var target_node: Node = null

func _ready():
	if enemy == null or not has_node(enemy):
		print("ERROR: Invalid target")
		queue_free()
		return

	target_node = get_node(enemy)
	# Optional: point the projectile initially
	look_at(target_node.global_position)

	# Auto-remove after lifetime
	await get_tree().create_timer(life_time).timeout
	queue_free()


func _process(delta):
	if target_node == null or not is_instance_valid(target_node):
		queue_free()
		return

	# Look at the target each frame
	look_at(target_node.global_position)

	# Move toward the target
	var direction = (target_node.global_position - global_position).normalized()
	global_position += direction * speed * delta

	# Optional: stop when close enough
	if global_position.distance_to(target_node.global_position) < 10:
		queue_free()  # reached target
