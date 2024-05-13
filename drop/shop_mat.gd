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
@onready var midSlot:GridContainer = $mid
@onready var rightSlot:GridContainer = $right
@onready var dropItem:Vector2 = $itemspawnpoint.global_position
@onready var leftbought:bool = false
@onready var midbought:bool = false
@onready var rightbought:bool = false
var player:Player

func _ready()->void:
	#print(leftSlot.visible)
	for i in get_children():
		if i.is_in_group("slot"):
			shopSlots.append(i)
	populateShopMat()
	#print($itemspawnpoint/Sprite2D.global_position)
	
#populate the world with representations of the items while filling an array with the scenes that correlate to the items to an internal array 
func populateShopMat()->void:
	for i in shopSlots:
		var artifact :Artifact= SqLiteController.selectRandomArtifact()
		i.resource = artifact
		shopInventory.append(artifact)
	#print(shopInventory)
	leftSlot.artifact = shopInventory[0]
	midSlot.artifact =shopInventory[1]
	rightSlot.artifact =shopInventory[2]
	

func _left_item_hover(body:Node2D)->void:
	if(body.is_in_group("Player") and leftbought == false):
		player = body
		leftSlot.show()
		if body.blood_count >= leftSlot.price:
			leftSlot.button.disabled =false
			#print("enough to buy left item")
		else:
			leftSlot.button.disabled =true
			#print("insufficient funds")
		#print("hovering left item"
	
	pass # Replace with function body.

func _left_item_exited(body:Node2D)->void:
	if(body.is_in_group("Player")):
		leftSlot.hide()
		
	
func buyleftItem()->void:
	player.gain_blood_count(-leftSlot.price)
	leftSlot.spawnItem()
	leftSlot.hide()
	closeSlot("left")
	leftbought = true
	

func _mid_item_hover(body)->void:
	if(body.is_in_group("Player") and midbought == false):
		player = body
		midSlot.show()
		if body.blood_count >= midSlot.price:
			midSlot.button.disabled =false
		else:
			midSlot.button.disabled =true
	

func _mid_item_exited(body)->void:
	if(body.is_in_group("Player")):
		midSlot.hide()


func _buy_mid_item()->void:
	player.gain_blood_count(-midSlot.price)
	midSlot.spawnItem()
	midSlot.hide()
	closeSlot("mid")
	midbought = true


func _right_item_hover(body)->void:
	if(body.is_in_group("Player") and rightbought==false):
		player = body
		rightSlot.show()
		if body.blood_count >= rightSlot.price:
			rightSlot.button.disabled =false
		else:
			rightSlot.button.disabled =true
	

func _right_item_exited(body)->void:
	if(body.is_in_group("Player")):
		rightSlot.hide()

func _buy_right_item()->void:
	player.gain_blood_count(-rightSlot.price)
	rightSlot.spawnItem()
	rightSlot.hide()
	closeSlot("right")
	rightbought = true
	
func closeSlot(which:String)->void:
	if which == "left":
		shopSlots[0].resource = ResourceDirectory.get_resource("NONE")
	if which == "mid":
		shopSlots[1].resource = ResourceDirectory.get_resource("NONE")
	if which == "right":
		shopSlots[2].resource = ResourceDirectory.get_resource("NONE")
