@tool
class_name Lives
extends Control
## A sort of progress bar that displays discrete values with heart shapes.

const DEFAULT_COLOR: Color = Color("#f8221c")
const DEFAULT_SIZE: float = 50.0

## Total number of hearts, including both active and inactive.
@export var max_value: int = 10
## Number of hearts that are active.
@export var value: int = 5
## Size of the hearts.
@export var heart_size: float = DEFAULT_SIZE
## Color of filled hearts.
@export var color_filled: Color = DEFAULT_COLOR
## Color of unfilled hearts.
@export var color_unfilled: Color = Color("#860907")
## Color of background.
@export var color_background: Color = Color("#0008")


## Listen to health changes.
func _ready() -> void:
	Events.lives_changed.connect(_on_lives_changed)


## Draw filled hearts, followed by remaining unfilled hearts,
## all on a solid color background.
func _draw() -> void:
	draw_rect(Rect2(
			position,
			Vector2(
					heart_size * max_value * 0.75 + heart_size * 0.25,
					heart_size)
			),
			color_background
	)
	for i: int in range(max_value):
		var color: Color = color_filled if i < value else color_unfilled
		var pos_x: Vector2 = Vector2(i * heart_size * 0.75, 0)
		Lives.draw_heart(self, heart_size, pos_x, color)


## Draw a heart shape with a given position, size, and color.
static func draw_heart(
		canvas: CanvasItem,
		size: float = DEFAULT_SIZE,
		pos: Vector2 = Vector2(0, 0),
		color: Color = DEFAULT_COLOR) -> void:
	var radius: float = sin(deg_to_rad(45)) * 0.5 * size / 2
	canvas.draw_circle(Vector2(0.375, 0.375) * size + pos, radius, color)
	#draw_arc(
			#Vector2(0.375, 0.375) * size + pos_x, radius - 1,
			#0, TAU, 50, Color("#0004"),
			#2
	#)
	canvas.draw_circle(Vector2(0.625, 0.375) * size + pos, radius, color)
	#draw_arc(
			#Vector2(0.625, 0.375) * size + pos_x, radius - 1,
			#0, TAU, 50, Color("#0004"),
			#2
	#)
	var points: PackedVector2Array = PackedVector2Array([
			Vector2(0.5, 0.25) * size + pos,
			Vector2(0.75, 0.5) * size + pos,
			Vector2(0.5, 0.75) * size + pos,
			Vector2(0.25, 0.5) * size + pos,
	])
	canvas.draw_colored_polygon(points, color)


## Redraw HUD life bar with given values.
func _on_lives_changed(current_lives: int, max_lives: int) -> void:
	value = current_lives
	max_value = max_lives
	queue_redraw()
