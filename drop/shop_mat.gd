extends Node2D

@onready var left: Marker2D = $common_item1
@onready var mid: Marker2D = $common_item2
@onready var right: Marker2D = $special_item
#shop slots array visualizes the inventory of the shop
@onready var shopSlots: Array
#shop inventory array holds the actual scene of the item to be spit out after it is bought
@onready var shopInventory: Array
# Called when the node enters the scene tree for the first time.
@onready var leftSlot:GridContainer =  $left
@onready var dropItem:Vector2 = $itemspawnpoint.position

var player:Player

func _ready():
	#print(leftSlot.visible)
	for i in get_children():
		if i.is_in_group("slot"):
			shopSlots.append(i)
	populateShopMat()
	
#populate the world with representations of the items while filling an array with the scenes that correlate to the items to an internal array 
func populateShopMat()->void:
	for i in shopSlots:
		var artifact :Artifact= SqLiteController.selectRandomArtifact()
		i.resource = artifact
		shopInventory.append(artifact)
	#print(shopInventory)
	leftSlot.artifact = shopInventory[0]
	#midSlot.artifact =shopInventory[1]
	#rightSlot.artifact =shopInventory[2]
	

func _left_item_hover(body:Node2D)->void:
	if(body.is_in_group("Player")):
		player = body
		leftSlot.show()
		if body.blood_count >= leftSlot.price:
			leftSlot.button.disabled =false
			#print("enough to buy left item")
		else:
			leftSlot.button.disabled =true
			#print("insufficient funds")
		#print("hovering left item")
	pass # Replace with function body.

func _left_item_exited(body:Node2D)->void:
	if(body.is_in_group("Player")):
		leftSlot.hide()
		#print("no longer hovering")
	pass # Replace with function body.


func buyleftItem():
	player.gain_blood_count(-leftSlot.price)
	print(leftSlot.itemScene)
	print(dropItem)
	var itemInstance = leftSlot.itemScene.instantiate()
	itemInstance.set("global_position", player.global_position)
	print(itemInstance.position)
	
