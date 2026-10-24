class_name WeaponHolder
extends Node3D
signal weapon_changed(weapon_data: WeaponData)
## Configurar en el Inspector: arrastra la escena del arma inicial
@export var starting_weapon: PackedScene
## Configurar en el Inspector: arrastra el .tres con los datos
@export var weapon_data: WeaponData
## Referencia al BoneAttachment3D donde va el arma (configurar en Inspector)
@export var hand_slot: BoneAttachment3D
var current_weapon_instance: Node3D
func _ready() -> void:
	if starting_weapon:
		equip(starting_weapon, weapon_data)
func equip(weapon_scene: PackedScene, data: WeaponData) -> void:
	# Quitar arma anterior
	if current_weapon_instance:
		current_weapon_instance.queue_free()
	
	# Poner arma nueva
	weapon_data = data
	current_weapon_instance = weapon_scene.instantiate()
	hand_slot.add_child(current_weapon_instance)
	weapon_changed.emit(weapon_data)
## Llamado desde Call Method Track del AnimationPlayer
func activate_hitbox() -> void:
	var hitbox := current_weapon_instance.find_child("HitboxArea", false) as Area3D
	if hitbox:
		hitbox.monitoring = true
func deactivate_hitbox() -> void:
	var hitbox := current_weapon_instance.find_child("HitboxArea", false) as Area3D
	if hitbox:
		hitbox.monitoring = false
## Llamado desde Call Method Track del AnimationPlayer
func spawn_projectile() -> void:
	var spawn_point := current_weapon_instance.find_child("ProjectileSpawn", false) as Marker3D
	if spawn_point == null:
		return
	# Instanciar proyectil como escena autocontenida
	# El proyectil se mueve solo (tiene su propio script simple)
	# TODO: asignar la escena del proyectil por arma
