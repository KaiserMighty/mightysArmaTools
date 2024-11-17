extends Window

@onready var v_box_container = $VBoxContainer/ScrollContainer/VBoxContainer
const ONE_ITEM = preload("res://components/selector_items/oneItem.tscn")


func _on_button_pressed():
	var item = ONE_ITEM.instantiate()
	v_box_container.add_child(item)
	v_box_container.move_child(item, v_box_container.get_child_count() - 2)


func _on_confirm_pressed():
	var length = v_box_container.get_child_count()
	if length > 1:
		var selector_data = PackedStringArray([])
		for n in length - 1:
			if v_box_container.get_child(n).item_data != "":
				selector_data.append(v_box_container.get_child(n).item_data)
		get_parent().set_meta("data", selector_data)
		queue_free()
	else:
		queue_free()

func load_data(data):
	for n in data.size():
		var item = ONE_ITEM.instantiate()
		item.item_data = data[n]
		v_box_container.add_child(item)
		v_box_container.move_child(item, v_box_container.get_child_count() - 2)
		item.load_data(data[n])
	
