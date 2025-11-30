extends Node2D

@export var enemy: NodePath        # NodePath to the target player
@export var life_time := 0.15      # How long the sword exists

func _ready():
	print("Sword created")

	if enemy == null:
		print("ERROR: Sword has no target")
		return

	if not has_node(enemy):
		print("ERROR: Enemy path invalid:", enemy)
		return

	var target = get_node(enemy)
	look_at(target.global_position)  # Point the sword at the enemy
	print("Sword pointing at enemy:", target.global_position)

	await get_tree().create_timer(life_time).timeout
	queue_free()
	print("Sword deleted")
