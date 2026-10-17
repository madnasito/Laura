extends "res://adventure_character.gd"

@onready var animation_tree := %Knight/AnimationPlayer

func _physics_process(delta: float) -> void:
	_movement(delta)
	print(velocity)
	print(velocity.normalized())
