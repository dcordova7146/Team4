extends Node2D

#singleton script used to access resources from anywhere
var cache : Dictionary = {}

@export_dir var resources_folder

#load all resources from the resources folder into a cache dictionary for easier access
func _ready()->void:
	var folder = DirAccess.open(resources_folder)
	folder.list_dir_begin()
	var file_name = folder.get_next()
	
	while file_name != "":
		#print(file_name)
		cache[file_name] = load(resources_folder + "/" + file_name)
		file_name = folder.get_next()
	#print(cache)
	#print(cache["Artifical Blood.tres"])

func get_resource(name:String)->Artifact:
	return cache[name + ".tres"]
	
