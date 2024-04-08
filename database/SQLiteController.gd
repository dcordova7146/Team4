extends Control

var database : SQLite
var randomId = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	database = SQLite.new()
	database.path = "res://database/data.db"
	database.open_db()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_create_table_button_down():
	var table = {
		"itemId" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true },
		"itemName" : {"data_type" : "text"},
		"itemEffect" : {"data_type" : "text"},
		"itemCost" : {"data_type" : "int"},
		"iconPath" : {"data_type" : "text"}
	}
	database.create_table("items", table)
	pass # Replace with function body.


func _on_insert_data_button_down():
	var data = {
		"itemName" : $ItemNameField.text,
		"itemEffect" : $ItemEffectField.text,
		"itemCost" : int($ItemCostField.text),
	}
	database.insert_row("items",data)
	pass # Replace with function body.


func _on_select_data_button_down():
	print(database.select_rows("items","",["*"]))
	pass # Replace with function body.


func _on_update_data_button_down():
	database.update_rows("items", "itemId = 1", {
		"itemName" : $ItemNameField.text,
		"itemEffect" : $ItemEffectField.text,
		"itemCost" : int($ItemCostField.text),
	})
	pass # Replace with function body.


func _on_delete_data_button_down():
	pass # Replace with function body.


func _on_custom_select_button_down():
	pass # Replace with function body.
