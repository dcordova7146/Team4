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
#@onready var dummyitem = preload("res://artifacts/Artifacts/artificial_blood.tscn")

var player:Player

func _ready():
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
		
	
func buyleftItem():
	player.gain_blood_count(-leftSlot.price)
	leftSlot.spawnItem()


func _mid_item_hover(body):
	if(body.is_in_group("Player")):
		player = body
		midSlot.show()
		if body.blood_count >= midSlot.price:
			midSlot.button.disabled =false
		else:
			midSlot.button.disabled =true
	pass

func _mid_item_exited(body):
	if(body.is_in_group("Player")):
		midSlot.hide()


func _buy_mid_item():
	player.gain_blood_count(-midSlot.price)
	midSlot.spawnItem()


func _right_item_hover(body):
	if(body.is_in_group("Player")):
		player = body
		rightSlot.show()
		if body.blood_count >= rightSlot.price:
			rightSlot.button.disabled =false
		else:
			rightSlot.button.disabled =true

func _right_item_exited(body):
	if(body.is_in_group("Player")):
		rightSlot.hide()

func _buy_right_item():
	player.gain_blood_count(-rightSlot.price)
	rightSlot.spawnItem()
