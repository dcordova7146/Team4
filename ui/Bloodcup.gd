extends Sprite2D

var blood_count := 0


func set_blood_cup(new_count: int) -> void:
	get_node("bloodcount").text = "x" +str(blood_count)
	
