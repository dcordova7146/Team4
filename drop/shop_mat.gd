##Diego C, Karwei K
extends Node2D

@export var buy_box_scene: PackedScene

## Visualizes the inventory of the shop.
var item_slots: Array[ItemSlot]
var buy_boxes: Array[BuyBox]

## Grab each individual slot prepare it to be populated
func _ready() -> void:
	for node: Node in get_children():
		if node.is_in_group("slot"):
			item_slots.append(node)
	populate()


## Populate the world with representations of the items
## while filling an array with the scenes that correlate to the items
## to an internal array.
func populate() -> void:
	for item_slot: ItemSlot in item_slots:
		# Put random artifact in slot.
		var artifact: Artifact = SqLiteController.get_random_artifact()
		item_slot.item = artifact
		# Create buy box.
		var new_buy_box: BuyBox = buy_box_scene.instantiate()
		new_buy_box.item_slot = item_slot
		add_child(new_buy_box)
		new_buy_box.artifact = artifact
		new_buy_box.position = Vector2(item_slot.position.x, -75)
		# Connect functions to show/hide buy box upon approach.
		var area_2d: Area2D = item_slot.find_children("*", "Area2D")[0]
		area_2d.body_entered.connect(_on_item_approach.bind(new_buy_box))
		area_2d.body_exited.connect(_on_item_reproach.bind(new_buy_box))


## Show buy box if it hasn't been bought yet.
func _on_item_approach(player: Player, buy_box: BuyBox) -> void:
	if buy_box.is_purchased:
		return
	buy_box.show()
	buy_box.player = player
	# Disable buy button if player can't afford.
	var is_affordable: bool = player.blood_count >= buy_box.artifact.price
	buy_box.button.disabled = not is_affordable


## Hide buy box.
func _on_item_reproach(_player: Player, buy_box: BuyBox) -> void:
	buy_box.hide()
