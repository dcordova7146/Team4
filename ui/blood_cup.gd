## Karwei K
extends HBoxContainer

@onready var label: Label = $Label

var _blood_count: int = 0


func set_blood_cup(new_count: int) -> void:
	_blood_count = new_count
	label.text = "×" + str(_blood_count)
