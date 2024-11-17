extends Node

var ownerNode : Node = null
var file_extension : String = "*.cfg"
var save_file : FileAccess = null
var save_path : String = ""
var data : Dictionary = {}

func init_globals(node, ext):
	ownerNode = node
	file_extension = ext
	save_file = null
	data.clear()


func saveData(ext):
	if ext == "*.cfgu":
		saveData_uniform()


func loadData(ext):
	if ext == "*.cfgu":
		loadData_uniform()


func saveData_uniform():
	ownerNode.update_categories()
	data = {
		"patches_title" : ownerNode.patches_title,
		"class_prefix" : ownerNode.class_prefix,
		"base_inheritance" : ownerNode.base_inheritance,
		"weapon_inheritance" : ownerNode.weapon_inheritance,
		"vehicle_inheritance" : ownerNode.vehicle_inheritance,
		"models" : ownerNode.models,
		"category_data" : ownerNode.category_data,
	}
	save_file.store_line(JSON.stringify(data))
	data.clear()


func loadData_uniform():
	data = JSON.parse_string(save_file.get_line())
	ownerNode.patches_title = data["patches_title"]
	ownerNode.class_prefix = data["class_prefix"]
	ownerNode.base_inheritance = data["base_inheritance"]
	ownerNode.weapon_inheritance = data["weapon_inheritance"]
	ownerNode.vehicle_inheritance = data["vehicle_inheritance"]
	ownerNode.models = data["models"]
	ownerNode.category_data = data["category_data"]
	data.clear()
	ownerNode.data_loaded()
