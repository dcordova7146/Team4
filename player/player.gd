## Contributors: James, Diego, Karwai
class_name Player
extends CharacterBody2D

## Initial number of lives.
@export var lives: int = 2
## Max number of lives.
@export var max_lives: int = 8
## Move speed multiplier.
@export var speed: int = 125
## Area2D for detecting collisions w/ nodes that don't push.
@onready var area_2d: Area2D = $Area2D
## Timer until invincibility after losing a life wears off.
@onready var invincibility_timer: Timer = $InvincibilityTimer
## Timer until visibility is toggled.
@onready var blink_timer: Timer = $BlinkTimer
##artifact inventory not the same place guns are kept
@onready var inventory = get_node("../HUD/Inventory")
## modifier for damage dealt, affected by artifacts
var damage_mul := 1.0
## The part that should be flipped depending on the position of the cursor.
##
## Flipping the root node creates a feedback loop,
## as the angle the to the cursor rapidly changes as it's flipped.
## So, we flip only nodes w/ visual appearances.
@onready var flip: Node2D = $Flip
## What holds equippable items (i.e. weapons).
@onready var hand: Node2D = $Flip/Hand
## Times reload progress.
@onready var reload_timer: Timer = $ReloadTimer
## Shows gun reload progress visible only when reloading.
@onready var reload_bar: ProgressBar = $ReloadBar
## Message to reload; shown if trigger held when gun unloaded.
@onready var reload_label: Label = $ReloadLabel
## Index of the currently active weapon.
var _equipped_weapon_index: int = 0
## The closest gun on the ground.
##
## Has an outline if close enough, and is taken upon the "use" action.
var nearest_gun: Gun
## Amount of blood.
var blood_count: int = 0:
	set(new_count):
		blood_count = new_count
		Events.blood_count_changed.emit(new_count)
## Whether these is a gun nearby, and thus able to be taken.
var _is_near_gun: bool = false
var _is_reloading_gun: bool:
	get:
		return not reload_timer.is_stopped()

func _ready() -> void:
	# Broadcast health state on ready so it may be rendered by the HUD.
	Events.lives_changed.emit(lives, max_lives)
	# Check for the takeable group changing.
	Events.takeable_group_changed.connect(_on_takeable_group_changed)
	# Set active weapon to first slot.
	_equip_weapon(0)
	# Connect stackable artifact signal
	Events.damage_multiplier.connect(set_dmg_mul)
	# Connect single use artifact signal
	Events.speed_multiplier.connect(set_speed_mul)
	


func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	_get_input()
	_process_collisions()
	_face_mouse_cursor(mouse_pos)
	_get_equipped_weapon().aim(mouse_pos)
	if _is_near_gun:
		_outline_nearest_gun()
	# Update reload progress bar if reloading.
	if _is_reloading_gun:
		reload_bar.value = reload_timer.time_left


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		# Hold trigger only if not reloading.
		if not _is_reloading_gun:
			# Show a reload reminder if empty.
			_update_reload_label()
			_get_equipped_weapon().hold_trigger()
	elif event.is_action_released("primary_action"):
		_get_equipped_weapon().release_trigger()
	elif event.is_action_pressed("reload"):
		_reload_equipped_gun()
	elif event.is_action_pressed("equip_weapon_slot_1"):
		_equip_weapon(0)
	elif event.is_action_pressed("equip_weapon_slot_2"):
		_equip_weapon(1)
	elif event.is_action_pressed("equip_weapon_slot_3"):
		_equip_weapon(2)
	elif event.is_action_pressed("equip_weapon_slot_4"):
		_equip_weapon(3)
	elif event.is_action_pressed("equip_weapon_slot_5"):
		_equip_weapon(4)
	elif event.is_action_pressed("equip_next_weapon_slot"):
		_equip_next_weapon()
	elif event.is_action_pressed("equip_previous_weapon_slot"):
		_equip_previous_weapon()
	elif event.is_action_pressed("use"):
		_take_nearest_weapon()
	elif event.is_action_pressed("drop_equipped_weapon"):
		_drop_equipped_weapon()


## Equip the weapon at the given index.
##
## Takes [param hide_old], which determines whether
## the previously equipped weapon will be hidden.
func _equip_weapon(index: int, hide_old: bool = true) -> int:
	# Can't equip index if not accessible.
	if not index < hand.get_child_count():
		return -1;
	# Interrupt reload, if doing so.
	reload_timer.stop()
	reload_bar.visible = false
	# Release trigger of previous, if any.
	var old_weapon: Gun = _get_equipped_weapon()
	if old_weapon:
		old_weapon.release_trigger()
		if hide_old:
			old_weapon.visible = false
	# Ensure next is visible.
	var new_weapon: Gun = hand.get_child(index)
	new_weapon.visible = true
	# Update index.
	_equipped_weapon_index = index
	_update_reload_label()
	# Signal to HUD.
	Events.active_weapon_changed.emit(new_weapon)
	return 0;


# Move the player according to cardinal direction input.
#grabs direction vector based on an input map of established keys associated with direction
func _get_input() -> void:
	var direction: Vector2 = Input.get_vector(
			"move_left", "move_right", "move_up", "move_down"
	)
	velocity = direction * speed
	move_and_slide()


## Run specific behavior upon collision with certain entities.
func _process_collisions() -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		var trap: Trap = collider as Trap
		if trap:
			_lose_life()


## Flip if the mouse is to the left, such that it faces the mouse.
func _face_mouse_cursor(mouse_pos: Vector2) -> void:
	var angle_to_mouse: float = global_position.angle_to_point(mouse_pos)
	if (abs(angle_to_mouse) < PI / 2):
		if flip.scale.x != 1:
			flip.scale.x = 1
	else:
		if flip.scale.x != -1:
			flip.scale.x = -1


## Return the active weapon among the weapons possessed.
func _get_equipped_weapon() -> Gun:
	if not _equipped_weapon_index < hand.get_child_count():
		return null
	return hand.get_child(_equipped_weapon_index)
	
	
# Show an outline around the nearest, takeable gun
# and remove the outline from the previously nearest gun if it exists.
func _outline_nearest_gun() -> void:
	var new_nearest: Gun = _get_nearest_gun()
	if nearest_gun and not nearest_gun == new_nearest:
		nearest_gun.hide_outline()
	new_nearest.show_outline()
	nearest_gun = new_nearest


## Reload the equipped gun, if any.
func _reload_equipped_gun() -> int:
	var gun: Gun = _get_equipped_weapon()
	# Don't if already reloading, gun not equipped, gun fully loaded,
	# gun has infinite bullets, or have no bullets to load.
	if (
			not gun or
			gun.is_loaded_fully or
			not gun.has_reserve_bullets or
			_is_reloading_gun or
			not gun.is_bullet_finite
	):
		# Update to show there is no ammo.
		_update_reload_label()
		return -1
	gun.release_trigger()
	# Begin timer to reload and show progress bar.
	reload_timer.wait_time = gun.reload_duration
	reload_bar.max_value = gun.reload_duration
	reload_bar.visible = true
	reload_timer.start()
	# Update to hide while reloading.
	_update_reload_label()
	return 0


## Equip the weapon in the next index, or
## after the index of the currently equipped weapon.
##
## Takes [param hide_old], which determines whether
## the previously equipped weapon will be hidden.
func _equip_next_weapon(hide_old: bool = true) -> void:
	# Roll over to first weapon.
	var next_index: int = _equipped_weapon_index + 1
	_equip_weapon(
			next_index
			if next_index < hand.get_child_count()
			else 0,
			hide_old
	)


## Equip the weapon in the previous index, or
## before the index of the currently equipped weapon.
func _equip_previous_weapon() -> void:
	# Roll over to last weapon.
	var previous_index: int = _equipped_weapon_index - 1
	_equip_weapon(
			previous_index
			if previous_index > -1
			else hand.get_child_count() - 1
	)


## Take the nearest weapon, if any, and equip it.
func _take_nearest_weapon() -> int:
	var nearest: Gun = _get_nearest_gun()
	if not nearest:
		return -1
	# Move weapon to player's hand.
	nearest.get_parent().remove_child(nearest)
	hand.add_child(nearest)
	nearest.position = Vector2.ZERO
	# Stop monitoring for player entering gun,
	# since it's only relevant for takeables.
	nearest.monitoring = false
	# Equip takeable, which is at the end of the list of children.
	_equip_weapon(hand.get_child_count() - 1)
	return 0


## Move the currently equipped weapon, if droppable, 
## out of the hand and equip the next weapon.
func _drop_equipped_weapon() -> int:
	var gun: Gun = _get_equipped_weapon()
	# Don't drop undroppable guns.
	if not gun.is_droppable:
		return -1
	# Equip the next gun.
	_equip_next_weapon(false)
	# Move index back in anticipation of indexes shifting from removal.
	if gun.get_index() < _equipped_weapon_index:
		_equipped_weapon_index -= 1
	# Move gun off player.
	hand.remove_child(gun)
	get_parent().add_child(gun)
	gun.global_position = global_position
	# Have gun monitor for entered bodies.
	gun.monitoring = true
	return 0


## Subtract a life.
func _lose_life() -> void:
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
	print("going invincible")
	invincibility_timer.start()
	# Make appearance blink rapidly.
	blink_timer.start()


## Add a life if max lives not reached.
func _gain_life() -> void:
	## Don't if at max lives.
	if lives == max_lives:
		return
	lives += 1
	Events.lives_changed.emit(lives, max_lives)


## Return the nearest gun in the "takeable" group.
func _get_nearest_gun() -> Gun:
	var takeables: Array[Node] = get_tree().get_nodes_in_group("takeable")
	if takeables.is_empty():
		return null;
	# Find nearest takeable.
	var nearest: Node2D = takeables[0]
	for takeable: Node2D in takeables:
		if (
				global_position.distance_to(takeable.global_position) <
				global_position.distance_to(nearest.global_position)
		):
			nearest = takeable
	return nearest


## Show label to reload if equipped weapon is unloaded gun.
func _update_reload_label() -> void:
	var gun: Gun = _get_equipped_weapon()
	if gun:
		reload_label.visible = not gun.is_loaded and not _is_reloading_gun
		if gun.has_reserve_bullets:
			reload_label.text = "Reload"
		else:
			reload_label.text = "No ammo"
	else:
		reload_label.visible = false


## Toggle visibility.
func _on_blink_timer_timeout() -> void:
	visible = not visible


## Stop blinking and ensure visibility.
func _on_invincibility_timer_timeout() -> void:
	blink_timer.stop()
	visible = true
	# Take more damage if still touching enemy.
	var bodies: Array[Node2D] = area_2d.get_overlapping_bodies()
	for body: Node2D in bodies:
		var enemy: Skull = body as Skull
		if enemy:
			_lose_life()


## Set bool _is_near_gun to true if there are takeables, otherwise false.
func _on_takeable_group_changed() -> void:
	var takeables: Array[Node] = get_tree().get_nodes_in_group("takeable")
	_is_near_gun = not takeables.is_empty()


## Load bullets from reserve up to the max loadable,
## otherwise the rest in reserve.
func _on_reload_timer_timeout() -> void:
	var gun: Gun = _get_equipped_weapon()
	if not gun:
		return
	var space_left: int = gun.loaded_bullet_count_max - gun.loaded_bullet_count
	var amount_to_load: int = mini(space_left, gun.reserve_bullet_count)
	gun.loaded_bullet_count += amount_to_load
	gun.reserve_bullet_count -= amount_to_load
	_update_reload_label()
	# Hide progress bar.
	reload_bar.visible = false


## Take damage on enemy contact.
func _on_area_2d_body_entered(body: Node2D) -> void:
	var enemy: Skull = body as Skull
	if enemy:
		_lose_life()
		
##obtain an artifact either through buying or picking up to add to inventory of artifacts
func obtain_artifact(artifact:Artifact)->void:
	#print("Inventory: ")
	#print(inventory)
	inventory.add_artifact(artifact)
	
func set_dmg_mul(amount: float):
	var percent = (amount/100.0) + 1.0
	damage_mul *= percent
	
func set_speed_mul(amount: float):
	var percent = (amount/100.0) + 1.0
	speed *= percent
