extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -635.0

@onready var sprite_2d = $Sprite2D
@onready var weapon_socket = $WeaponSocket

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Weapon system
@export var sword_scene: PackedScene
@export var player2_node: NodePath


func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta

	# JUMP
	if Input.is_action_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Jump pressed")

	# MOVE
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# FLIP SPRITE
	if direction != 0:
		sprite_2d.flip_h = direction < 0

	# ATTACK
	if Input.is_action_just_pressed("attack_p1"):
		print("Attack pressed")

		if sword_scene == null:
			print("ERROR: Sword Scene is not assigned")
			return
		
		if not is_instance_valid(weapon_socket):
			print("ERROR: WeaponSocket is missing")
			return
		
		if player2_node == null:
			print("ERROR: Player2 not assigned")
			return

		spawn_sword()


func spawn_sword():
	print("Spawning sword...")

	var sword = sword_scene.instantiate()

	sword.global_position = weapon_socket.global_position
	sword.player2_node = player2_node

	get_tree().current_scene.add_child(sword)

	print("Sword spawned at", sword.global_position)
