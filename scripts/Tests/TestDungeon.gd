## Contributors: Diego, Karwai

class_name TestDungeon extends Node2D

signal game_restarted
signal game_exited_to_menu


## Pass signal to main, then delete self.
func _on_pause_menu_game_restarted() -> void:
	game_restarted.emit()
	queue_free()


## Pass signal to main, then delete self.
func _on_pause_menu_game_exited_to_menu() -> void:
	game_exited_to_menu.emit()
	queue_free()
