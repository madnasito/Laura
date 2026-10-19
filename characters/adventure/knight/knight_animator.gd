extends "res://characters/adventure/scripts/character_animator.gd"

class_name KnightAnimator

## Habilidades específicas del Caballero
func attack_chop() -> void:
	playback.travel("melee_1h_attack_chop")

func attack_stab() -> void:
	playback.travel("melee_1h_attack_stab")

func block(active: bool) -> void:
	if active:
		playback.travel("melee_blocking")
	else:
		playback.travel("movement")

func dodge(direction: Vector2) -> void:
	set("parameters/Movement/focused/dodge/blend_position", direction)
	playback.travel("focused")
