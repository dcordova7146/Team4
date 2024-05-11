extends Resource
class_name Artifact

@export var icon: Texture2D
@export var name: String
@export_enum("Common","Uncommon", "Rare")
var rarity: String
@export_multiline var description: String
signal aquired_item(item)

func itemAquired(item : Artifact):
	emit_signal("aquired_item", item)

func setIcon(path: String)->void:
	#print(path)
	#load(path)
	ResourceLoader.load(path)

func setName(itemName: String)->void:
	name = itemName

func setRarity(itemRarity: String)->void:
	rarity = itemRarity

func setDesc(itemDesc: String)->void:
	description = itemDesc
