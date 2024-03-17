extends Node2D

@onready var marker: Marker2D = $Marker2D

func _on_body_entered(body: Node2D) -> void:
	print("Door entered")
	body.global_position = marker.global_position
