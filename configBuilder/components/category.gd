extends VBoxContainer

@onready var category_title = $CategoryTitle
@onready var category_data = $CategoryData

const CATEGORY_EDIT = preload("res://components/category_edit.tscn")

var cat_title : String = ""
var internal_title : String = ""
var internal_data = PackedStringArray([])
var internal_data_advanced = PackedStringArray([])
var display_data : String = ""


func _on_category_del_pressed():
	queue_free()


func _on_category_title_text_changed(new_text):
	cat_title = new_text


func _on_category_select_text_changed(new_text):
	internal_title = new_text


func _on_category_edit_pressed():
	var item = CATEGORY_EDIT.instantiate()
	add_child(item)
	set_meta("data", internal_data)
	set_meta("adv", internal_data_advanced)
	item.title = "Edit Category: '{title}'".format({"title":cat_title})
	item.load_data(internal_data, internal_data_advanced)
	get_tree().paused = true
	await item.tree_exiting
	get_tree().paused = false
	internal_data = get_meta("data")
	internal_data_advanced = get_meta("adv")
	update_display_data()

func load_data(load_title, load_int, load_data1, load_data2):
	cat_title = load_title
	internal_title = load_int
	internal_data = load_data1
	internal_data_advanced = load_data2
	update_display_data()

func update_display_data():
	if internal_data.size() > 0:
		category_data.text = "\n".join(internal_data)
