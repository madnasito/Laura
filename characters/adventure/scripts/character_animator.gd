# res://characters/character_animator.gd
class_name CharacterAnimator
extends AnimationTree

var character: CharacterBody3D
var playback: AnimationNodeStateMachinePlayback

# character state vars
var is_on_floor := true
var is_jumping := false
var is_falling := false
var is_moving := false
var speed_ratio := 0.0
var vertical_speed := 0.0

# Action flags (input/combat)
var is_attacking := false
var combo_buffered := false
var is_blocking := false
var is_hit := false
var is_dead := false

# ── Combo Step (0 = Not attacking, 1 = Attack 1, 2 = Attack 2, 3 = Attack 3) ──
var combo_step := 0

func _ready() -> void:
	playback = get("parameters/Main/playback")

func _physics_process(delta: float) -> void:
	if not character:
		return
	
	# detect ground
	is_on_floor = character.is_on_floor()
	vertical_speed = character.velocity.y
	
	# feeling high
	is_jumping = not is_on_floor and vertical_speed > 0.1
	is_falling = not is_on_floor and vertical_speed < -0.1
	
	# Horizontal movement
	var horizontal_velocity := Vector2(character.velocity.x, character.velocity.z)
	var max_speed: float = character.get("move_speed") if "move_speed" in character else 8.0
	speed_ratio = clampf(horizontal_velocity.length() / max_speed, 0.0, 1.0)
	set("parameters/Main/movement/movement/blend_position", speed_ratio)
	
	# ── AUTOMATIC COMBO RESET ──
	# Whenever the StateMachine is in "movement", reset combo_step to 0!
	if combo_step > 0 and playback and playback.get_current_node() == "movement":
		combo_step = 0
	
	if is_jumping:
		playback.travel('jumping')
	
	
	set("parameters/Main/movement/movement/blend_position", speed_ratio)
	
	print('is_on_floor: ', is_on_floor)
	print('is_jumping: ', is_jumping)
	print('is_falling: ', is_falling)
	print('is_moving: ', is_moving)
	print('speed_ratio: ', speed_ratio)
	print('vertical_speed: ', vertical_speed)
	print('is_attacking: ', is_attacking)
	print('is_blocking: ', is_blocking)
	print('is_hit: ', is_hit)
	print('is_dead: ', is_dead)
	print('combo step: ', combo_step)
	

# ----- COMBAT ACTIONS -----

# Combat State Setters (called by Knight or Input)
func set_blocking(active: bool) -> void:
	is_blocking = active

func request_attack() -> void:
	# Increment combo step (capped at 3)
	combo_step = mini(combo_step + 1, 3)

func consume_combo_buffer() -> void:
	combo_buffered = false

func reset_attack() -> void:
	is_attacking = false
	combo_buffered = false

func trigger_hit() -> void:
	is_hit = true
	combo_step = 0

func reset_hit() -> void:
	is_hit = false
