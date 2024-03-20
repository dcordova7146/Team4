extends Node2D

const BULLET: PackedScene = preload("res://projectile/shotgun_shell.tscn")

## How long until the gun can be fired again.
@export var cooldown_duration: float = 1
## How long until the gun is fired again when primary action key held.
@export var auto_fire_duration: float = 0.5
## Whether the gun is still cooling down from the last time it was fired.
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


## Shoot a bullet or a cone of bullets on primary action pressed.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		shoot()
		shooting_timer.start()
	if event.is_action_released("primary_action"):
		shooting_timer.stop()


## Face the mouse position at all times.
func _physics_process(_delta: float) -> void:
	gun_pivot.look_at(get_global_mouse_position())
	if is_cooling_down:
		cooldown_bar.value = cooldown_timer.time_left


## Create a bullet or a cone of bullets with the position and rotation of this gun.
func shoot() -> void:
	# Don't shoot if still cooling down.
	if is_cooling_down:
		return;
	
	for i in range(4):  # Adjust the number of bullets in the cone as needed
		var spread_angle = i * 0.1 # Adjust the spread angle for tighter spread
		var new_bullet: Node2D = BULLET.instantiate()
		new_bullet.global_position = bullet_hole.global_position
		new_bullet.global_rotation = bullet_hole.global_rotation + spread_angle
		bullet_hole.add_child(new_bullet)

		# Create another bullet that spreads in the opposite direction (upwards)
		var opposite_spread_angle = -spread_angle
		var opposite_bullet: Node2D = BULLET.instantiate()
		opposite_bullet.global_position = bullet_hole.global_position
		opposite_bullet.global_rotation = bullet_hole.global_rotation + opposite_spread_angle
		bullet_hole.add_child(opposite_bullet)
	
	# Begin cooldown, show its progress bar, and start timer to end it.
	is_cooling_down = true
	cooldown_bar.visible = true
	cooldown_timer.start()


## Shoot when shooting timer times out.
func _on_shooting_timer_timeout() -> void:
	shoot()


## When cooldown is over, cooling down is over and the progress bar is hidden.
func _on_cooldown_timer_timeout() -> void:
	is_cooling_down = false
	cooldown_bar.visible = false
