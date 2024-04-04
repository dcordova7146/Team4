## Contributors: James, Karwai
class_name Gun
extends Node2D

signal loaded_bullet_count_changed()
signal reserve_bullet_count_changed()
signal shot_attempted_without_loaded_bullets()

## Bullet fired.
@export var bullet: PackedScene = preload("res://projectile/bullet_square.tscn")
## Damage dealt to the enemy contacted.
@export var damage: float = 10.0
## Speed of the bullet.
@export var speed: float = 250.0
## Range of the bullet.
@export var max_range: float = 1000.0
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
## Scale of the bullet.
@export var bullet_scale: Vector2 = Vector2(1, 1)

## Current number of bullets loaded.
var loaded_bullet_count: int:
	set(value):
		loaded_bullet_count = value
		# Hide reload reminder when no longer empty.
		if loaded_bullet_count > 0:
			reload_label.visible = false
		loaded_bullet_count_changed.emit()

## Current number of bullets reserved.
var reserve_bullet_count: int:
	set(value):
		reserve_bullet_count = value
		reserve_bullet_count_changed.emit()

## Whether the gun still cooling down from the last time it was fired.
##
## If true, bullets cannot be shot.
var _is_cooling_down: bool = false

@onready var gun_pivot: Marker2D = $GunPivot
@onready var shooting_timer: Timer = $ShootingTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var reload_bar: ProgressBar = $ReloadBar
@onready var reload_label: Label = $ReloadLabel
@onready var bullet_hole: Node2D = %BulletHole
@onready var sprite_2d: Sprite2D = $GunPivot/Sprite


## Set up timers for shooting and cooldown and value of cooldown progress bar.
func _ready() -> void:
	reset_bullet_count()
	shooting_timer.wait_time = auto_fire_duration
	cooldown_timer.wait_time = cooldown_duration
	reload_timer.wait_time = reload_duration
	reload_bar.max_value = reload_duration
	


## When primary action pressed, fire.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		# Don't fire if still cooling down.
		if not _is_cooling_down:
			# Show a reload reminder if empty.
			if loaded_bullet_count == 0:
				reload_label.visible = true;
			else:
				_shoot()
		shooting_timer.start()
	if event.is_action_released("primary_action"):
		shooting_timer.stop()
		
	
	elif event.is_action_pressed("reload"):
		# Don't reload if loaded bullets already at max.
		if not loaded_bullet_count == loaded_bullet_count_max:
			_reload()


## Face the mouse position at all times.
func _physics_process(_delta: float) -> void:
	gun_pivot.look_at(get_global_mouse_position())
	if not reload_timer.is_stopped():
		reload_bar.value = reload_timer.time_left


## Set the amount of bullets loaded and reserved to full.
func reset_bullet_count() -> void:
	loaded_bullet_count = loaded_bullet_count_max
	reserve_bullet_count = reserve_bullet_count_max


## Create bullets and begin cooldown until it can be fired again.
func _shoot() -> void:
	# If no loaded bullets or reloading, don't shoot.
	if loaded_bullet_count == 0 or not reload_timer.is_stopped():
		shot_attempted_without_loaded_bullets.emit()
		return;
	_spawn_bullets()
	# Begin cooldown and start timer to end it.
	_is_cooling_down = true
	cooldown_timer.start()


## Begin the reload timer if it'sn't running.
func _reload() -> void:
	if reload_timer.is_stopped():
		reload_bar.visible = true
		reload_timer.start()


## Behavior of gun upon firing.
## Intended to be overridden by various gun types.
## By default, a single bullet is fired.
func _spawn_bullets() -> void:
	_add_bullet()


## Instantiate and add a bullet to the root scene
## with the position and rotation of the bullet hole, unless otherwise given.
func _add_bullet(
		bullet_position: Vector2 = bullet_hole.global_position,
		bullet_rotation: float = bullet_hole.global_rotation) -> void:
	# Don't add a bullet if none loaded.
	if loaded_bullet_count == 0:
		return;
	elif loaded_bullet_count < 0:
		printerr("_loaded_bullet_count is less than 0!")
	# Comsume a bullet from the magazine.
	loaded_bullet_count -= 1;
	var new_bullet: Bullet = _instantiate_bullet()
	new_bullet.global_position = bullet_position
	new_bullet.global_rotation = bullet_rotation
	get_tree().root.add_child(new_bullet)


## Instantiate a bullet with the properties specified on the gun.
func _instantiate_bullet() -> Bullet:
	var new_bullet: Bullet = bullet.instantiate()
	new_bullet.damage = damage
	new_bullet.speed = speed
	new_bullet.max_range = max_range
	new_bullet.scale = bullet_scale
	return new_bullet


## Shoot when shooting timer times out....
func _on_shooting_timer_timeout() -> void:
	_shoot()


## When cooldown is over, cooling down is over and the progress bar is hidden.
func _on_cooldown_timer_timeout() -> void:
	_is_cooling_down = false


## Load bullets from reserve up to the max loadable,
## otherwise the rest in reserve.
func _on_reload_timer_timeout() -> void:
	var space_left: int = loaded_bullet_count_max - loaded_bullet_count
	var amount_to_load: int = mini(space_left, reserve_bullet_count)
	loaded_bullet_count += amount_to_load
	reserve_bullet_count -= amount_to_load
	reload_bar.visible = false
