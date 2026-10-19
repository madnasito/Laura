# res://characters/character_animator.gd
class_name CharacterAnimator
extends AnimationTree

var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	# Tu playback está dentro del nodo "Movement"
	playback = get("parameters/Movement/playback")

## Llamado por el personaje en cada frame físico
func update_movement(velocity: Vector3, max_speed: float, is_grounded: bool) -> void:
	# 1. Calculamos velocidad horizontal (ignorando Y para no afectar con la gravedad)
	var horizontal_velocity := Vector2(velocity.x, velocity.z)
	var speed_ratio := clampf(horizontal_velocity.length() / max_speed, 0.0, 1.0)
	
	# 2. Alimentamos el BlendSpace de movimiento (0.0 = Idle, 0.5 = Walk, 1.0 = Run)
	set("parameters/Movement/movement/movement/blend_position", speed_ratio)
	
	# 3. Condiciones de salto / suelo (si usas advance conditions en el AnimationTree)
	# set("parameters/conditions/is_grounded", is_grounded)
