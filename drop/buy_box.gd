class_name BuyBox
extends GridContainer

@onready var price_label: Label = $Panel/PriceLabel
@onready var button: Button = $Button
@onready var item_spawn_point: Marker2D = $"../ItemSpawnPoint"

var artifact: Artifact:
	set(new_artifact):
		artifact = new_artifact
		# Set the price to whats inside the current item slot.
		price = SqLiteController.getArtifactPrice(artifact.name)
		price_label.text = "%s\n🩸%d" % [artifact.name, price]
var price: int
var item_slot: ItemSlot
var player: Player
var is_purchased: bool = false


func _on_button_pressed() -> void:
	is_purchased = true
	hide()
	player.blood_count -= price
	item_slot.item = ResourceDirectory.get_resource("NONE")
	var file_name: String = (artifact.name).replace(" ", "_").to_lower()
	var tscn_path: String = ("res://artifacts/Artifacts/" + file_name + ".tscn")
	var item_scene: PackedScene = load(tscn_path)
	var item_instance: Node = item_scene.instantiate()
	item_spawn_point.add_child(item_instance)
	item_instance.set_deferred("global_position", item_spawn_point.global_position)
