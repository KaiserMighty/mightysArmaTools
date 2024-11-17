extends Control

@onready var base_data = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceData/BaseData
@onready var weapon_data = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceData/WeaponData
@onready var vehicle_data = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceData/VehicleData
@onready var inheritance_base = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceButtons/InheritanceBase
@onready var inheritance_weapons = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceButtons/InheritanceWeapons
@onready var inheritance_vehicles = $CanvasLayer/VBoxContainer/VBoxContainer/InheritanceButtons/InheritanceVehicles

const ONE_SELECTOR = preload("res://components/oneSelector.tscn")
const EXPORT_DATA = preload("res://components/exportData.tscn")

var patches_title : String = ""
var base_inheritance = PackedStringArray([])
var weapon_inheritance = PackedStringArray([])
var vehicle_inheritance = PackedStringArray([])

func _ready():
	Global.init_globals("*.cfgu")


func _on_patches_title_text_changed(new_text):
	patches_title = new_text


func _on_inheritance_base_pressed():
	inheritance_base.set_meta("data", base_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_base.add_child(child)
	child.title = "Base Inheritance"
	child.load_data(base_inheritance)
	await child.tree_exiting
	base_inheritance = inheritance_base.get_meta("data")
	base_data.text = "\n".join(base_inheritance)


func _on_inheritance_weapons_pressed():
	inheritance_weapons.set_meta("data", weapon_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_weapons.add_child(child)
	child.title = "CfgWeapons Inheritance"
	child.load_data(weapon_inheritance)
	await child.tree_exiting
	weapon_inheritance = inheritance_weapons.get_meta("data")
	weapon_data.text = "\n".join(weapon_inheritance)


func _on_inheritance_vehicles_pressed():
	inheritance_vehicles.set_meta("data", vehicle_inheritance)
	var child = ONE_SELECTOR.instantiate()
	inheritance_vehicles.add_child(child)
	child.title = "CfgVehicles Inheritance"
	child.load_data(vehicle_inheritance)
	await child.tree_exiting
	vehicle_inheritance = inheritance_vehicles.get_meta("data")
	vehicle_data.text = "\n".join(vehicle_inheritance)


func _on_export_pressed():
	var window = EXPORT_DATA.instantiate()
	window.load_data(vehicle_inheritance)
