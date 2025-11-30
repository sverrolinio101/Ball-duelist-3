extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -635.0
const CROUCH_VELOCITY = 1200.0  # Downward slam speed

@onready var sprite_2d = $Sprite2D
@onready var weapon_socket = $Character

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Character selection
@export var character_name: String = "Knight"

# Weapon system
@export var weapon: PackedScene
@export var enemy: NodePath
@export_enum("Player 1", "Player 2") var player_id: int = 0  # 0 = Player 1, 1 = Player 2

# Player key mapping
var player_data = {
	1: {"move_left": "move_left", "move_right": "move_right", "jump": "jump", "attack": "attack", "crouch": "crouch"},
	2: {"move_left": "move_left_2", "move_right": "move_right_2", "jump": "jump_2", "attack": "attack_2", "crouch": "crouch_2"}
}

# Runtime player ID
var actual_player_id: int

# Character database
var character_db = preload("res://Player/Character/characters.gd").new()  # Adjust path to your character.gd

func _ready():
	actual_player_id = player_id + 1  # dataset keys are 1 and 2

	# Assign weapon based on selected character
	weapon = character_db.get_default_weapon(character_name)
	if weapon == null:
		push_warning("No weapon assigned for character %s" % character_name)
	else:
		print("Weapon assigned for", character_name, ":", weapon)


func _physics_process(delta):
	# --- GRAVITY ---
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- HORIZONTAL MOVEMENT ---
	var left_key = player_data[actual_player_id]["move_left"]
	var right_key = player_data[actual_player_id]["move_right"]

	var direction = 0
	if Input.is_action_pressed(left_key):
		direction -= 1
	if Input.is_action_pressed(right_key):
		direction += 1

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- JUMP ---
	var jump_key = player_data[actual_player_id]["jump"]
	if Input.is_action_pressed(jump_key) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- CROUCH / REVERSE-JUMP ---
	var crouch_key = player_data[actual_player_id]["crouch"]
	if Input.is_action_just_pressed(crouch_key) and not is_on_floor():
		velocity.y = CROUCH_VELOCITY  # Slam downward

	# --- MOVE CHARACTER ---
	move_and_slide()

	# --- FLIP SPRITE ---
	if direction != 0:
		sprite_2d.flip_h = direction < 0

	# --- ATTACK ---
	var attack_key = player_data[actual_player_id]["attack"]
	if Input.is_action_just_pressed(attack_key):
		if weapon == null:
			push_warning("Weapon not assigned")
			return
		if not is_instance_valid(weapon_socket):
			push_warning("Weapon socket missing")
			return
		if enemy == null:
			push_warning("Enemy not assigned")
			return
		attack()


func attack():
	var weapon_instance = weapon.instantiate()
	weapon_instance.global_position = weapon_socket.global_position
	weapon_instance.enemy = enemy  # NodePath, matches sword script
	get_tree().current_scene.add_child(weapon_instance)
