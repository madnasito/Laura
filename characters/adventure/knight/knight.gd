extends "res://characters/adventure/scripts/adventure_character.gd"

@onready var knight_animator: KnightAnimator = animator as KnightAnimator

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("attack_primary"):
		#knight_animator.attack_chop()
	#
	#if event.is_action_pressed("block"):
		#knight_animator.block(true)
	#elif event.is_action_released("block"):
		#knight_animator.block(false)
#func use_ability_primary() -> void:
	#anim_playback.travel("attack")
