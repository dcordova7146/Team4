##Diego Cordova
class_name Trap
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $Sprite/AnimationPlayer
@export var can_hurt: bool = false

func _on_trap_body_entered(player: Player) -> void:
	print("trap area entered")
	activate_trap()
	
	
func activate_trap() -> void:
	animation_player.play("activate")
	
