extends StaticBody2D

@onready var campfireDetection = $Area2D/CollisionShape2D
# Called when the node enters the scene tree for the first time.
@export var used:bool = false
func _ready():
	used = false
	#print("camp")
	#print(used)
	$Sprite2D/AnimationPlayer.play("fire")

#each camp is one use
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and used == false:
		print("entered if")
		campfireDetection.disabled = true
		$Area2D.monitoring = false
		$Area2D.monitorable = false
		Events.choiceBegun.emit(body)
		used = true
	
	
		
