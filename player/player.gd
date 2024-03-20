## Contributors: James, Diego, Karwai

extends CharacterBody2D

## Initial number of lives.
@export var lives: int = 2
## Max number of lives.
@export var max_lives: int = 8
# Move speed multiplier.
#export allows it to be modifiable outside code and in the editor
@export var speed: int = 125
## Timer until invincibility after losing a life wears off.
@onready var invincibility_timer: Timer = $InvincibilityTimer
## Timer until visibility is toggled.
@onready var blink_timer: Timer = $BlinkTimer


## Broadcast health state on ready so it may be rendered by the HUD.
func _ready() -> void:
	Events.lives_changed.emit(lives, max_lives)

func _physics_process(_delta: float) -> void:
	get_input()
	process_collisions()


# Move the player according to cardinal direction input.
#grabs direction vector based on an input map of established keys associated with direction
func get_input() -> void:
	var direction: Vector2 = Input.get_vector(
			"move_left", "move_right", "move_up", "move_down"
	)
	velocity = direction * speed
	move_and_slide()
	

## Run specific behavior upon collision with certain entities.
func process_collisions() -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		var enemy: Skull = collider as Skull
		if enemy:
			lose_life()
		var life: Life = collider as Life
		if life:
			# Remove collided lives.
			life.queue_free()
			gain_life()


## Subtract a life.
func lose_life() -> void:
	# Don't if invincible.
	if not invincibility_timer.is_stopped():
		return
	lives -= 1
	# Let pause menu know if player died (i.e. game over).
	if lives == 0: 
		Events.player_died.emit()
	# Let HUD life bar know health state.
	Events.lives_changed.emit(lives, max_lives)
	# Make temporarily invincible.
	invincibility_timer.start()
	# Make appearance blink rapidly.
	blink_timer.start()


## Add a life if max lives not reached.
func gain_life() -> void:
	if lives == max_lives:
		return
	lives += 1
	Events.lives_changed.emit(lives, max_lives)


## Toggle visibility.
func _on_blink_timer_timeout() -> void:
	visible = not visible


## Stop blinking and ensure visibility.
func _on_invincibility_timer_timeout() -> void:
	blink_timer.stop()
	visible = true
