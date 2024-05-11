extends Control

var database : SQLite
var randomId = 2
var populated: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	database = SQLite.new()
	database.path = "res://database/data.db"
	#if(!database.open_db()):
		#createShopTables()
		#populateTable()
	database.open_db()
	createShopTables()
	populateTable()
	
		
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
	database.query("CREATE TABLE IF NOT EXISTS " + "items" + table )
	#database.create_table("items", table)
		
	
	pass # Replace with function body.

#if shop tables does not exist on start up create the tables and populate the tables with items in the game
func createShopTables():
	var tableTemplate = {
		"itemId" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true },
		"itemName" : {"data_type" : "text"},
		"itemDescription" : {"data_type" : "text"},
		"itemCost" : {"data_type" : "int"},
		"itemRarity": {"data_type" : "text"},
		"iconPath" : {"data_type" : "text"}
	}
	#if(database.create_table("itemTable", tableTemplate)):
		#populateTable()
	database.query(
	"CREATE TABLE IF NOT EXISTS " + "items" + "(
	\"itemId\"	INTEGER NOT NULL UNIQUE,
	\"itemName\"	TEXT NOT NULL,
	\"itemDescription\"	TEXT NOT NULL,
	\"itemCost\"	INTEGER NOT NULL,
	\"itemRarity\"	TEXT NOT NULL,
	\"iconPath\"	INTEGER,
	PRIMARY KEY(\"itemId\" AUTOINCREMENT)
	);")
	#print(database.create_table("itemTable", tableTemplate))
func populateTable():
	## common items
	insertData("Vitamins","2% increase damage Stackable",3,"Common","res://tempAssets/drops/items/tile020.png")
	insertData("Carrot Berry","range increase on pistol 10% stackable",3,"Common","res://tempAssets/drops/items/tile000.png")
	insertData("Dangle Berries","last 2 bullets on pistol deal 30% extra damage stackable",3,"Common","res://tempAssets/drops/items/tile001.png")
	insertData("Square Cherry","increase projectile size on pistol by 10% stackable",5,"Common","res://tempAssets/drops/items/tile003.png")
	insertData("Prickle Berry","increase pierce on pistol by 1 stackable",5,"Common","res://tempAssets/drops/items/tile005.png")
	insertData("Gamer Fuel","5% increase to move speed",5,"Common","res://tempAssets/drops/items/tile037.png")
	insertData("Bad4Us","5% increase to Reload speed + 5% increase to fire rate -5% damage stackable",2,"Common","res://tempAssets/drops/items/tile022.png")
	insertData("Shower in a Can","Fully heal hearts take 10% extra damage from enemies",1,"Common","res://tempAssets/drops/items/tile021.png")
	insertData("Starberry Leaf","10% increase to sword damage",5,"Common","res://tempAssets/drops/items/tile009.png")
	## uncommon items
	insertData("Starberries","duplicate current pistol-berry mods onto burst rifle ",10,"Uncommon","res://tempAssets/drops/items/tile019.png")
	insertData("Jala Fruit","duplicate current pistol-berry mods onto machine gun",10,"Uncommon","res://tempAssets/drops/items/tile014.png")
	insertData("Muhnanah","duplicate current pistol-berry mods onto shotgun",10,"Uncommon","res://tempAssets/drops/items/tile013.png")
	insertData("Atomic Fruit","duplicate current pistol-berry mods onto sniper",10,"Uncommon","res://tempAssets/drops/items/tile016.png")
	insertData("Artificial Blood","Gain 25 drops of blood",-1,"NULL","res://tempAssets/drops/items/tile067.png")
	insertData("Ginger","Cleanse negative effect on 1 random held item",10,"Uncommon","res://tempAssets/drops/items/tile059.png")
	insertData("Firewood","Load pistol with fire bullets - frozen enemies are no longer invulnerable *replaces current element",15,"Uncommon","res://tempAssets/drops/items/tile063.png")
	insertData("Frozen Shard","Load pistol with ice bullets - slow enemies on hit *replaces current element",3,"Uncommon","res://tempAssets/drops/items/tile068.png")
	insertData("Save State","Recover from death with 1 heart",30,"Uncommon","res://tempAssets/drops/items/tile043.png")
	##Rare Items
	insertData("Cool Sunnies","\"I Dont need to reload!\" - Auto reload guns on swap",50,"Rare","res://tempAssets/drops/items/tile070.png")
	insertData("Epic Visor","\"1 gun is enough\" - Gain stacks on a gun per rooms cleared without swapping guns *5% increase to damage per stack reset on gun swap",50,"Rare","res://tempAssets/drops/items/tile049.png")
	insertData("Hard Hat","\"safe measure\" - Enemies are hurt on touching player 25% off their max health",50,"Rare","res://tempAssets/drops/items/tile055.png")
	insertData("Speeder","\"zoom zoom\" - increase move speed by 30%",50,"Rare","res://tempAssets/drops/items/tile042.png")
	insertData("VIP Membership","\"VIP access!\" - 25% off all items forever",50,"Rare","res://tempAssets/drops/items/tile040.png")
	insertData("Black Credit Card","\"Even better than the gold credit card\" - 25% cash back on purchases at all stores *rounded down",50,"Rare","res://tempAssets/drops/items/tile046.png")
	insertData("Berry Scraps","\"5 second rule!\" - gain a heart back on entering a new room",50,"Rare","res://tempAssets/drops/items/tile051.png")
	insertData("Plan Z","\"Everything in one conveniently sized pill\" - all stats plus 15%",50,"Rare","res://tempAssets/drops/items/tile035.png")
	insertData("Medicinal Herbs","\"Its medicinal!\" - immune to negative effects from items",50,"Rare","res://tempAssets/drops/items/tile025.png")
	pass
	
func insertData(name: String, description: String, cost:int, rarity: String, path: String):
	database.query(
		"INSERT OR IGNORE INTO " + "itemTable" + " (name, description, amount, rarity, image_path) VALUES
		 (" + name +", " +  description+ ", " + str(cost) + ", " + rarity + ", " + path + ");")
	
	var data = {
		"itemName" : name,
		"itemDescription" : description,
		"itemCost" : cost,
		"itemRarity": rarity,
		"iconPath" : path,	
	}
	#database.insert_row("itemTable", data)
	pass

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
