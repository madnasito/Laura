extends "res://characters/adventure/scripts/adventure_character.gd"

@onready var knight_animator: KnightAnimator = animator as KnightAnimator

func _unhandled_input(event: InputEvent) -> void:
	if not animator:
		return
	
	if event.is_action_pressed("attack_primary"):
		animator.start_attack()
	
	if event.is_action_pressed("block"):
		animator.set_blocking(true)
	elif event.is_action_released("block"):
		animator.set_blocking(false)
