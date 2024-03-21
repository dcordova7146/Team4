## Contributors: James, Karwai
class_name Gun
extends Node2D

## Bullet fired.
@export var bullet: PackedScene = preload("res://projectile/bullet_square.tscn")
## Damage dealt to the enemy contacted.
@export var damage: float = 10.0
## Speed of the bullet.
@export var speed: float = 250.0
## Range of the bullet.
@export var max_range: float = 1000.0
## Scale of the bullet.
@export var bullet_scale: Vector2 = Vector2(1, 1)
## How long until the gun can be fired again.
@export var cooldown_duration: float = 0.5
## How long until the game is fired again when primary action key held.
@export var auto_fire_duration: float = 0.5
## Whether the gun still cooling down from the last time it was fired.
##
## If true, bullets cannot be shot.
var is_cooling_down: bool = false
@onready var gun_pivot: Marker2D = $GunPivot
@onready var shooting_timer: Timer = $ShootingTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cooldown_bar: ProgressBar = $CooldownBar
@onready var bullet_hole: Node2D = %BulletHole


## Set up timers for shooting and cooldown and value of cooldown progress bar.
func _ready() -> void:
	shooting_timer.wait_time = auto_fire_duration
	cooldown_timer.wait_time = cooldown_duration
	cooldown_bar.max_value = cooldown_duration


## When primary action pressed, fire.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		# Don't fire if still cooling down.
		if not is_cooling_down:
			_fire()
		shooting_timer.start()
	if event.is_action_released("primary_action"):
		shooting_timer.stop()


## Face the mouse position at all times.
func _physics_process(_delta: float) -> void:
	gun_pivot.look_at(get_global_mouse_position())
	if is_cooling_down:
		cooldown_bar.value = cooldown_timer.time_left


## Create bullets and begin cooldown until it can be fired again.
func _fire() -> void:
	_create_bullets()
	# Begin cooldown, show its progress bar, and start timer to end it.
	is_cooling_down = true
	cooldown_bar.visible = true
	cooldown_timer.start()


## Create bullets at the bullet hole.
func _create_bullets() -> void:
	var new_bullet: Bullet = _create_bullet()
	new_bullet.global_position = bullet_hole.global_position
	new_bullet.global_rotation = bullet_hole.global_rotation
	get_tree().root.add_child(new_bullet)


## Create a single bullet.
func _create_bullet() -> Bullet:
	var new_bullet: Bullet = bullet.instantiate()
	new_bullet.damage = damage
	new_bullet.speed = speed
	new_bullet.max_range = max_range
	new_bullet.scale = bullet_scale
	return new_bullet


## Shoot when shooting timer times out....
func _on_shooting_timer_timeout() -> void:
	_fire()


## When cooldown is over, cooling down is over and the progress bar is hidden.
func _on_cooldown_timer_timeout() -> void:
	is_cooling_down = false
	cooldown_bar.visible = false
