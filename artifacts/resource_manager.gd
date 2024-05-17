extends Node2D
#singleton script used to access resources from anywhere
var cache : Dictionary = {}

@export_dir var resources_folder: String = "res://artifacts/Resources"

#load all resources from the resources folder into a cache dictionary for easier access
func _ready() -> void:
	var folder: DirAccess = DirAccess.open(resources_folder)
	folder.list_dir_begin()
	var file_name: String = folder.get_next()
	
	while file_name != "":
		cache[file_name] = load(resources_folder + "/" + file_name)
		file_name = folder.get_next()

func get_resource(resource_name: String) -> Artifact:
	return cache[resource_name + ".tres"]
	
