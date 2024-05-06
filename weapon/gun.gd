## Contributors: James, Karwai
class_name Gun
extends Area2D

signal loaded_bullet_count_changed()
signal reserve_bullet_count_changed()
signal shot_attempted_without_loaded_bullets()

## Bullet fired.
@export var bullet: PackedScene = preload("res://projectile/bullet.tscn")
## Bullet damage.
@export var damage: float = 10.0
## Bullet speed.
@export var speed: float = 250.0
## Bullet range.
@export var max_range: float = 1000.0
## Bullet scale.
@export var bullet_scale: Vector2 = Vector2(1, 1)
## Seconds until it can be fired again.
@export var cooldown_duration: float = 0.5
## Seconds until it automatically fires again while the primary action key is held.
@export var auto_fire_duration: float = 0.5
## Seconds for it to reload.
@export var reload_duration: float = 1.0
## Max number of bullets loaded.
@export var loaded_bullet_count_max: int = 10
## Max number of bullets reserved.
@export var reserve_bullet_count_max: int = 100
## Whether it can be dropped.
@export var is_droppable: bool = true
## Number of enemies a bullet can hit before being deleted.
@export var pierce: int = 1
## Whether bullets pierce a finite number of enemies.
@export var is_pierce_finite: bool = true
## Whether a finite number of bullets exist.
@export var is_bullet_finite: bool = true


## Current number of bullets loaded.
var loaded_bullet_count: int:
	set(value):
		loaded_bullet_count = value
		loaded_bullet_count_changed.emit()

## Current number of bullets reserved.
var reserve_bullet_count: int:
	set(value):
		reserve_bullet_count = value
		reserve_bullet_count_changed.emit()
var has_reserve_bullets: bool:
	get:
		return reserve_bullet_count > 0
var is_loaded: bool:
	get:
		return loaded_bullet_count > 0
var is_loaded_fully: bool:
	get:
		return loaded_bullet_count == loaded_bullet_count_max
## Whether it's still cooling down from the last time it was fired.
##
## If true, bullets cannot be shot.
var _is_cooling_down: bool:
	get:
		return not cooldown_timer.is_stopped()

@onready var pivot: Marker2D = $Pivot
@onready var muzzle: Marker2D = $Pivot/Muzzle
@onready var sprite_2d: Sprite2D = $Pivot/Sprite
@onready var shooting_timer: Timer = $ShootingTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var outline_shader: Shader = load("res://drop/outline.gdshader")

## Set up timers for shooting and cooldown and value of cooldown progress bar.
func _ready() -> void:
	_reset_bullet_count()
	shooting_timer.wait_time = auto_fire_duration
	cooldown_timer.wait_time = cooldown_duration


## Aim the pivot towards the given target.
func aim(target: Vector2) -> void:
	pivot.look_at(target)


## Shoot, and start a timer to shoot regularly thereafter.
func hold_trigger() -> void:
	# Don't fire if still cooling down or not loaded.
	if not _is_cooling_down or loaded_bullet_count == 0:
		_shoot()
	shooting_timer.start()


## Stop the timer for automatic shooting.
func release_trigger() -> void:
	if not shooting_timer.is_stopped():
		shooting_timer.stop()


## Set the amount of bullets loaded and reserved to full.
func _reset_bullet_count() -> void:
	loaded_bullet_count = loaded_bullet_count_max
	reserve_bullet_count = reserve_bullet_count_max


## Create bullets and begin cooldown until it can be fired again.
func _shoot() -> int:
	# Don't if no loaded bullets.
	if loaded_bullet_count == 0:
		return -1;
	_spawn_bullets()
	# Begin cooldown and start timer to end it.
	cooldown_timer.start()
	return 0


## Show a 1-pixel white outline around sprite 2D.
func show_outline() -> void:
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = outline_shader
	sprite_2d.material = shader_material


## Remove outline.
func hide_outline() -> void:
	sprite_2d.material = null


## Behavior upon firing.
## Intended to be overridden.
## By default, a single bullet is fired.
func _spawn_bullets() -> void:
	_add_bullet()


## Instantiate and add a bullet to the root scene
## with the position and rotation of the bullet hole, unless otherwise given.
func _add_bullet(
		bullet_position: Vector2 = muzzle.global_position,
		bullet_rotation: float = muzzle.global_rotation) -> void:
	# Don't if none loaded.
	if loaded_bullet_count == 0:
		return;
	elif loaded_bullet_count < 0:
		printerr("_loaded_bullet_count is less than 0!")
	# Consume a loaded bullet.
	if is_bullet_finite:
		loaded_bullet_count -= 1;
	var new_bullet: Bullet = _instantiate_bullet()
	new_bullet.global_position = bullet_position
	new_bullet.global_rotation = bullet_rotation
	get_tree().root.add_child(new_bullet)


## Instantiate a bullet with the properties specified.
func _instantiate_bullet() -> Bullet:
	var new_bullet: Bullet = bullet.instantiate()
	new_bullet.damage = damage
	new_bullet.speed = speed
	new_bullet.max_range = max_range
	new_bullet.scale = bullet_scale
	new_bullet.pierce = pierce
	new_bullet.is_pierce_finite = is_pierce_finite
	return new_bullet


## Shoot when shooting timer times out....
func _on_shooting_timer_timeout() -> void:
	_shoot()


## When cooldown is over, cooling down is over...
func _on_cooldown_timer_timeout() -> void:
	return


func _on_body_entered(_body: Node2D) -> void:
	add_to_group("takeable")
	Events.takeable_group_changed.emit()


func _on_body_exited(_body: Node2D) -> void:
	remove_from_group("takeable")
	Events.takeable_group_changed.emit()
	hide_outline()
