class_name Artifact
extends Resource

@export var icon: Texture2D
@export var name: String
@export_enum("Common","Uncommon", "Rare")
var rarity: String
@export_multiline var description: String


func setIcon(path: String) -> void:
	ResourceLoader.load(path)

func setName(itemName: String) -> void:
	name = itemName

func setRarity(itemRarity: String) -> void:
	rarity = itemRarity

func setDesc(itemDesc: String) -> void:
	description = itemDesc
