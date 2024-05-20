## Karwei K
class_name HealthChange
extends RichTextLabel
## A number that appears where health changes occur,
## of the amount of health that was changed.

const COLOR_POSITIVE: Color = Color.GREEN
const COLOR_NEGATIVE: Color = Color.DARK_ORANGE

@export var relative_position: Vector2 = Vector2(0, 0)

var initial_position: Vector2 = position


func _process(_delta: float) -> void:
	position = initial_position + relative_position


func display(amount: int) -> void:
	var string: String = String.num_int64(amount)
	# Set color based on whether health was gained or lost.
	if amount > 0:
		push_color(COLOR_POSITIVE)
	elif amount < 0:
		push_color(COLOR_NEGATIVE)
		# Remove minus sign
		string = string.substr(1)
	initial_position = position
	($AnimationPlayer as AnimationPlayer).play("float_up")
	push_outline_color(Color.BLACK)
	push_outline_size(1)
	add_text(string)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "float_up":
		queue_free()
