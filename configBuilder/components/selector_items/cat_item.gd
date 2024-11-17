extends HBoxContainer

const CAT_ADVANCED = preload("res://components/selector_items/cat_advanced.tscn")

var displayName : String = ""
var className : String = ""
var resource : String = ""
var selected_model : String = ""
var exception_selection : String = ""
var exception_texture : String = ""
var special_class : String = ""

func _on_button_pressed():
	queue_free()


func _on_display_name_text_changed(new_text):
	displayName = new_text


func _on_class_name_text_changed(new_text):
	className = new_text


func _on_resource_text_changed(new_text):
	resource = new_text

func load_data(dName, cName, res):
	displayName = dName
	className = cName
	resource = res
	$DisplayName.text = displayName
	$ClassName.text = className
	$Resource.text = resource


func load_data_adv(model, exp_up, exp_lo, spec):
	selected_model = model
	exception_selection = exp_up
	exception_texture = exp_lo
	special_class = spec


func _on_advanced_pressed():
	var item = CAT_ADVANCED.instantiate()
	add_child(item)
	item.title = "Advanced Options: '{title}'".format({"title":displayName})
	item.load_data(selected_model, exception_selection, exception_texture, special_class)
	await item.tree_exiting
	exception_selection = get_meta("exception_upper")
	exception_texture = get_meta("exception_lower")
	selected_model = get_meta("model")
	special_class = get_meta("special")
