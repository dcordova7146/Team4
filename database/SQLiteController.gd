extends Control
#singleton script

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://database/data.db"
	#if(!database.open_db()):
		#createShopTables()
		#populate_table()
	database.open_db()
	createShopTables()
	populate_table()
	
#if shop tables does not exist on start up create the tables and populate the tables with items in the game
func createShopTables() -> void:
	var _tableTemplate: Dictionary = {
		"itemId" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true },
		"itemName" : {"data_type" : "text"},
		"itemDescription" : {"data_type" : "text"},
		"itemCost" : {"data_type" : "int"},
		"itemRarity": {"data_type" : "text"},
		"iconPath" : {"data_type" : "text"}
	}
	#if(database.create_table("itemTable", tableTemplate)):
		#populate_table()
	#print(database.create_table("itemTable", tableTemplate))
	#sql command mirroring above dictionary
	database.query(
	"CREATE TABLE IF NOT EXISTS " + "itemTable" + "(
	\"itemId\"	INTEGER NOT NULL UNIQUE,
	\"itemName\"	TEXT NOT NULL UNIQUE,
	\"itemDescription\"	TEXT NOT NULL,
	\"itemCost\"	INTEGER NOT NULL,
	\"itemRarity\"	TEXT NOT NULL,
	\"iconPath\"	INTEGER,
	PRIMARY KEY(\"itemId\" AUTOINCREMENT)
	);")
	
# table is immutable so it must be setup and populated before hand if it is not already created
func populate_table() -> void:
	## common items
	insert_data("Vitamins","2% increase damage Stackable",3,"Common","res://tempAssets/drops/items/tile020.png")
	#insert_data("Carrot Berry","range increase on pistol 10% stackable",3,"Common","res://tempAssets/drops/items/tile000.png")
	#insert_data("Dangle Berries","last 2 bullets on pistol deal 30% extra damage stackable",3,"Common","res://tempAssets/drops/items/tile001.png")
	insert_data("Square Cherry","increase projectile size on pistol by 10% stackable",5,"Common","res://tempAssets/drops/items/tile003.png")
	insert_data("Prickle Berry","increase pierce on pistol by 1 stackable",5,"Common","res://tempAssets/drops/items/tile005.png")
	insert_data("Gamer Fuel","5% increase to move speed",5,"Common","res://tempAssets/drops/items/tile037.png")
	insert_data("Bad4Us","5% increase to Reload speed and -5% damage stackable",2,"Common","res://tempAssets/drops/items/tile022.png")
	insert_data("Shower in a Can","Fully heal hearts take 10% extra damage from enemies",1,"Common","res://tempAssets/drops/items/tile021.png")
	insert_data("Starberry Leaf","10% increase to all weapon damage",10,"Common","res://tempAssets/drops/items/tile009.png")
	## uncommon items
	#insert_data("Starberries","duplicate current pistol-berry mods onto burst rifle ",10,"Uncommon","res://tempAssets/drops/items/tile019.png")
	#insert_data("Jala Fruit","duplicate current pistol-berry mods onto machine gun",10,"Uncommon","res://tempAssets/drops/items/tile014.png")
	#insert_data("Muhnanah","duplicate current pistol-berry mods onto shotgun",10,"Uncommon","res://tempAssets/drops/items/tile013.png")
	#insert_data("Atomic Fruit","duplicate current pistol-berry mods onto sniper",10,"Uncommon","res://tempAssets/drops/items/tile016.png")
	insert_data("Artificial Blood","Gain 25 drops of blood",-1,"Rare","res://tempAssets/drops/items/tile067.png")
	#insert_data("Ginger","Cleanse negative effect on 1 random held item",10,"Uncommon","res://tempAssets/drops/items/tile059.png")
	#insert_data("Firewood","Load pistol with fire bullets - frozen enemies are no longer invulnerable *replaces current element",15,"Uncommon","res://tempAssets/drops/items/tile063.png")
	#insert_data("Frozen Shard","Load pistol with ice bullets - slow enemies on hit *replaces current element",3,"Uncommon","res://tempAssets/drops/items/tile068.png")
	#insert_data("Save State","Recover from death with 1 heart",30,"Uncommon","res://tempAssets/drops/items/tile043.png")
	##Rare Items
	insert_data("Cool Sunnies","\"I Dont need to reload!\" - Auto reload Guns",50,"Rare","res://tempAssets/drops/items/tile070.png")
	#insert_data("Epic Visor","\"1 gun is enough\" - Gain stacks on a gun per rooms cleared without swapping guns *5% increase to damage per stack reset on gun swap",50,"Rare","res://tempAssets/drops/items/tile049.png")
	#insert_data("Hard Hat","\"safe measure\" - Enemies are hurt on touching player 25% off their max health",50,"Rare","res://tempAssets/drops/items/tile055.png")
	insert_data("Speeder","\"zoom zoom\" - increase move speed by 30%",50,"Rare","res://tempAssets/drops/items/tile042.png")
	#insert_data("VIP Membership","\"VIP access!\" - 25% off all items forever",50,"Rare","res://tempAssets/drops/items/tile040.png")
	#insert_data("Black Credit Card","\"Even better than the gold credit card\" - 25% cash back on purchases at all stores *rounded down",50,"Rare","res://tempAssets/drops/items/tile046.png")
	insert_data("Berry Scraps","\"5 second rule!\" - gain a heart back on entering a new room",50,"Rare","res://tempAssets/drops/items/tile051.png")
	insert_data("Plan Z","\"Everything in one conveniently sized pill\" - all stats plus 1",50,"Rare","res://tempAssets/drops/items/tile035.png")
	#insert_data("Medicinal Herbs","\"Its medicinal!\" - immune to negative effects from items",50,"Rare","res://tempAssets/drops/items/tile025.png")
	insert_data("Hero Hydration","Gain an extra max life Stackable", 25, "Rare", "res://tempAssets/items/tile026.png")
	
## Insert data helper function used to populate table with any item
func insert_data(item_name: String, description: String, cost: int, rarity: String, path: String) -> void:
	var params: Array = [item_name, description, str(cost), rarity, path]
	database.query_with_bindings(
			"INSERT OR IGNORE INTO itemTable \
			(itemName, itemDescription, itemCost, itemRarity, iconPath) \
			VALUES (?, ?, ?, ?, ?);", params
	)
	
## Create resources is a tool used to automate the process of creating custom resources and is only called once 
func create_resources() -> void:
	database.query("SELECT * FROM itemTable;")
	#var all_items = database.select_rows("itemTable", "", ["*"])
	for result: Dictionary in database.query_result:
		var resource: Artifact = Artifact.new()
		var icon_path: String = result["iconPath"]
		resource.setIcon(icon_path)
		var item_name: String = result["itemName"]
		resource.setName(item_name)
		var item_rarity: String = result["itemRarity"]
		resource.setRarity(item_rarity)
		var item_description: String = result["itemDescription"]
		resource.setDesc(item_description)
		var resource_path: String = "res://artifacts/Resources/" + item_name + ".tres"
		ResourceSaver.save(resource, resource_path)
		
func selectRandomArtifact() -> Artifact:
	database.query(
			"SELECT * \
			FROM itemTable \
			ORDER BY CASE \
			WHEN itemRarity = 'Common' \
			THEN RANDOM() * 0.5 \
			WHEN itemRarity = 'Uncommon' \
			THEN RANDOM() * 0.3 \
			WHEN itemRarity = 'Rare' \
			THEN RANDOM() * 0.2 \
			END DESC LIMIT 1;"
	)
	var item_name: String = database.query_result[0]["itemName"]
	return ResourceDirectory.get_resource(item_name)

func getArtifactPrice(artifactName: String) -> int:
	database.query(
			"SELECT itemCost \
			FROM itemTable \
			WHERE itemName = '" + artifactName + "';"
	)
	return database.query_result[0]["itemCost"]

#func selectArtifact(artifact: Artifact)-> PackedScene:
	#database.query("SELECT * FROM itemTable WHERE itemName = " + artifact.name)
	#var query: String = database.query_result[0]["itemName"]
	#var scenename = "res://artifacts/Artifacts/" + query.replace(" ", "_").to_lower() + ".tscn"
	#return load(scenename)
	#
	#
	
