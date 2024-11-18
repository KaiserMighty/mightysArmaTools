extends Control

@onready var models_data = $ScrollContainer/VBoxContainer/VBoxContainer/Models/ModelsData
@onready var models_button = $ScrollContainer/VBoxContainer/VBoxContainer/Models/ModelsButton
@onready var base_data = $ScrollContainer/VBoxContainer/VBoxContainer/Base/BaseData
@onready var inheritance_base = $ScrollContainer/VBoxContainer/VBoxContainer/Base/InheritanceBase
@onready var weapon_data = $ScrollContainer/VBoxContainer/VBoxContainer/Weapon/WeaponData
@onready var inheritance_weapons = $ScrollContainer/VBoxContainer/VBoxContainer/Weapon/InheritanceWeapons
@onready var vehicle_data = $ScrollContainer/VBoxContainer/VBoxContainer/Vehicle/VehicleData
@onready var inheritance_vehicles = $ScrollContainer/VBoxContainer/VBoxContainer/Vehicle/InheritanceVehicles
@onready var weapon_inherit = $ScrollContainer/VBoxContainer/VBoxContainer/Weapon/WeaponInherit
@onready var vehicle_inherit = $ScrollContainer/VBoxContainer/VBoxContainer/Vehicle/VehicleInherit
@onready var h_box_container = $ScrollContainer/VBoxContainer/ScrollContainer/HBoxContainer

const ONE_SELECTOR = preload("res://components/oneSelector.tscn")
const EXPORT_DATA = preload("res://components/exportData.tscn")
const CATEGORY = preload("res://components/category.tscn")

var patches_title : String = ""
var author : String = ""
var class_prefix : String = ""
var display_prefix : String = ""
var picture : String = ""
var dropped_model : String = "\\A3\\Characters_F\\Common\\Suitpacks\\suitpack_blufor_diver"
var base_inheritance = PackedStringArray(["ItemCore"])
var weapon_inheritance = PackedStringArray(["InventoryItem_Base_F", "ItemCore", "UniformItem", "Uniform_Base"])
var vehicle_inheritance = PackedStringArray(["B_Soldier_F", "B_Soldier_base_F", "B_Soldier_diver_base_F"])
var weapon_inherit_class : String = "Uniform_Base"
var vehicle_inherit_class : String = "B_Soldier_base_F"
var models = PackedStringArray([])
var category_data : Array = []

func _ready():
	Global.init_globals(self, "*.cfgu")
	base_data.text = "\n".join(base_inheritance)
	weapon_data.text = "\n".join(weapon_inheritance)
	vehicle_data.text = "\n".join(vehicle_inheritance)
	models_data.text = "\n".join(models)
	weapon_inheritance_dropdown(weapon_inheritance, weapon_inherit_class)
	vehicle_inheritance_dropdown(vehicle_inheritance, vehicle_inherit_class)
	$ScrollContainer/VBoxContainer/GridContainer/DroppedModel.text = dropped_model


func _on_patches_title_text_changed(new_text):
	patches_title = new_text


func _on_class_prefix_text_changed(new_text):
	class_prefix = new_text


func _on_author_field_text_changed(new_text):
	author = new_text


func _on_display_title_text_changed(new_text):
	display_prefix = new_text


func _on_picture_text_changed(new_text):
	picture = new_text


func _on_dropped_model_text_changed(new_text):
	dropped_model = new_text


func _on_inheritance_base_pressed():
	inheritance_base.set_meta("data", base_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_base.add_child(child)
	child.title = "Base Inheritance"
	child.load_data(base_inheritance)
	get_tree().paused = true
	await child.tree_exiting
	get_tree().paused = false
	base_inheritance = inheritance_base.get_meta("data")
	base_data.text = "\n".join(base_inheritance)


func _on_inheritance_weapons_pressed():
	inheritance_weapons.set_meta("data", weapon_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_weapons.add_child(child)
	child.title = "CfgWeapons Inheritance"
	child.load_data(weapon_inheritance)
	get_tree().paused = true
	await child.tree_exiting
	get_tree().paused = false
	weapon_inheritance = inheritance_weapons.get_meta("data")
	weapon_data.text = "\n".join(weapon_inheritance)


func _on_inheritance_vehicles_pressed():
	inheritance_vehicles.set_meta("data", vehicle_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_vehicles.add_child(child)
	child.title = "CfgVehicles Inheritance"
	child.load_data(vehicle_inheritance)
	get_tree().paused = true
	await child.tree_exiting
	get_tree().paused = false
	vehicle_inheritance = inheritance_vehicles.get_meta("data")
	vehicle_data.text = "\n".join(vehicle_inheritance)


func _on_modelsbutton_pressed():
	models_button.set_meta("data", models)
	var child = ONE_SELECTOR.instantiate()
	models_button.add_child(child)
	child.title = "Models"
	child.load_data(models)
	get_tree().paused = true
	await child.tree_exiting
	get_tree().paused = false
	models = models_button.get_meta("data")
	models_data.text = "\n".join(models)


func _on_export_pressed():
	update_categories()
	var export_data : Dictionary = {
		"patches_title" : patches_title,
		"author" : author,
		"class_prefix" : class_prefix,
		"display_prefix" : display_prefix,
		"picture" : picture,
		"dropped_model" : dropped_model,
		"base_inheritance" : base_inheritance,
		"weapon_inheritance" : weapon_inheritance,
		"vehicle_inheritance" : vehicle_inheritance,
		"models" : models,
		"category_data" : category_data,
	}
	var window = EXPORT_DATA.instantiate()
	add_child(window)
	window.load_data(export_data)
	get_tree().paused = true
	await window.tree_exiting
	get_tree().paused = false


func _on_add_cat_pressed():
	var item = CATEGORY.instantiate()
	h_box_container.add_child(item)
	h_box_container.move_child(item, h_box_container.get_child_count() - 2)


func weapon_inheritance_dropdown(data, selection):
	for n in data.size():
		weapon_inherit.add_item(data[n])
		if data[n] == selection:
			weapon_inherit.select(n)


func vehicle_inheritance_dropdown(data, selection):
	for n in data.size():
		vehicle_inherit.add_item(data[n])
		if data[n] == selection:
			vehicle_inherit.select(n)


func update_categories():
	category_data.clear()
	for n in h_box_container.get_child_count()-1:
		var cat_dict : Dictionary = {
			"cat_title" : h_box_container.get_child(n).cat_title,
			"internal_title" : h_box_container.get_child(n).internal_title,
			"internal_data" : h_box_container.get_child(n).internal_data,
			"internal_data_advanced" : h_box_container.get_child(n).internal_data_advanced,
			"display_data" : h_box_container.get_child(n).display_data
		}
		category_data.append(cat_dict)


func data_loaded():
	$ScrollContainer/VBoxContainer/GridContainer/PatchesTitle.text = patches_title
	$ScrollContainer/VBoxContainer/GridContainer/ClassPrefix.text = class_prefix
	$ScrollContainer/VBoxContainer/GridContainer/DisplayPrefix.text = display_prefix
	$ScrollContainer/VBoxContainer/GridContainer/AuthorField.text = author
	$ScrollContainer/VBoxContainer/GridContainer/Picture.text = picture
	$ScrollContainer/VBoxContainer/GridContainer/DroppedModel.text = dropped_model
	models_data.text = "\n".join(models)
	base_data.text = "\n".join(base_inheritance)
	weapon_data.text = "\n".join(weapon_inheritance)
	vehicle_data.text = "\n".join(vehicle_inheritance)
	models_button.set_meta("data", models)
	inheritance_base.set_meta("data", base_inheritance)
	inheritance_weapons.set_meta("data", weapon_inheritance)
	inheritance_vehicles.set_meta("data", vehicle_inheritance)
	weapon_inheritance_dropdown(weapon_inheritance, weapon_inherit_class)
	vehicle_inheritance_dropdown(vehicle_inheritance, vehicle_inherit_class)
	for n in h_box_container.get_child_count()-1:
		h_box_container.get_child(n).queue_free()
	for n in category_data.size():
		var item = CATEGORY.instantiate()
		h_box_container.add_child(item)
		h_box_container.move_child(item, h_box_container.get_child_count() - 2)
		item.load_data(
			category_data[n]["cat_title"], 
			category_data[n]["internal_title"], 
			category_data[n]["internal_data"], 
			category_data[n]["internal_data_advanced"])
		item.update_display_data()
