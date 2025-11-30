extends Node2D

@export var player2_node: NodePath
@export var life_time := 0.15


func _ready():
	print("Sword created")

	if player2_node == null:
		print("ERROR: Sword has no target")
		return

	if not has_node(player2_node):
		print("ERROR: Player2 path invalid:", player2_node)
		return

	var target = get_node(player2_node)
	look_at(target.global_position)

	print("Sword pointing at Player2:", target.global_position)

	await get_tree().create_timer(life_time).timeout
	queue_free()
	print("Sword deleted")
