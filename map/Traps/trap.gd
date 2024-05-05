class_name Trap
extends Sprite2D


# Called when the node enters the scene tree for the first time.

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var can_hurt: bool = false
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D

func _ready() -> void:
	hitbox.disabled = true



func _on_trap_body_entered(_body: Node2D) -> void:
	print("trap area entered")
	activate_trap()
	
	
	
func activate_trap() -> void:
	animation_player.play("activate")
	
