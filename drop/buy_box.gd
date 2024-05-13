extends GridContainer

# Called when the node enters the scene tree for the first time.
#set the price to whats inside the current item slot
@onready var itemScene:PackedScene
@onready var priceTag:Label = $Panel/priceLabel
@onready var artifact:Artifact
@onready var price:int
@onready var button:Button = $Button
@onready var markerLoc:Marker2D = $"../itemspawnpoint"
@onready var rootNode: Node2D = $".."
@onready var itemspawn

func _ready():
	visible = false
	call_deferred("setPrice")
	call_deferred("setScene")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func setPrice()->void:
	price = SqLiteController.getArtifactPrice(artifact.name)
	priceTag.text = "Price: " + str(price)

func setScene()->void:
	var fileName:String = (artifact.name).replace(" ", "_").to_lower()
	#print(fileName)
	var tscnPath:String= ("res://artifacts/Artifacts/" + fileName + ".tscn")
	itemScene = load(tscnPath)
	#print(tscnPath)

func spawnItem()->void:
	var itemInstance = itemScene.instantiate()
	markerLoc.add_child(itemInstance)
	itemInstance.set_deferred("global_position", markerLoc.global_position)
	
	

