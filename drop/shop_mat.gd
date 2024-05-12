extends Node2D

@onready var left: Marker2D = $common_item1
@onready var mid: Marker2D = $common_item2
@onready var right: Marker2D = $special_item
@onready var shopSlots: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i.is_in_group("slot"):
			shopSlots.append(i)
	populateShopMat()
	#print(shopSlots)
	
func populateShopMat():
	for i in shopSlots:
		i.resource = SqLiteController.selectRandomArtifact()
		

