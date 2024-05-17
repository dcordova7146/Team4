extends StaticBody2D
## Each camp is one use.

@export var used: bool = false

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready() -> void:
	animation_player.play("fire")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if used:
		return
	Events.choiceBegun.emit(body)
	used = true
