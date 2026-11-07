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
var is_blocking := false
var is_hit := false
var is_dead := false

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
	
	# movement and speed
	var horizontal_velocity := Vector2(character.velocity.x, character.velocity.z)
	var current_speed := horizontal_velocity.length()
	is_moving = is_on_floor and current_speed > 0.1
	var max_speed: float = character.get("move_speed") if "move_speed" in character else 8.0
	speed_ratio = clampf(current_speed / max_speed, 0.0, 1.0)
	
	if is_jumping:
		playback.travel('jumping')
	
	
	set("parameters/Main/movement/movement/blend_position", speed_ratio)

	set("parameters/Main/conditions/in_air", not is_on_floor)
	set("parameters/Main/jumping/conditions/on_ground", is_on_floor)
	
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
	
	# ground and air conditions
	set("parameters/conditions/on_ground", is_on_floor)
	set("parameters/conditions/in_air", not is_on_floor)
	set("parameters/conditions/is_jumping", not is_on_floor and vertical_speed > 0.1)
	set("parameters/conditions/is_falling", not is_on_floor and vertical_speed <= 0.1)


# Combat State Setters (called by Knight or Input)
func set_blocking(active: bool) -> void:
	set("parameters/Main/conditions/is_blocking", active)
	set("parameters/Main/conditions/is_not_blocking", not active)

func start_attack() -> void:
	set("parameters/Main/conditions/is_attacking", true)
	playback.travel('attack')

func reset_attack() -> void:
	set("parameters/Main/conditions/is_attacking", false)

func trigger_hit() -> void:
	set("parameters/Main/conditions/is_hit", true)

func reset_hit() -> void:
	set("parameters/Main/conditions/is_hit", false)
