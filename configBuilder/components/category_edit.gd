extends Window

@onready var v_box_container = $VBoxContainer/ScrollContainer/VBoxContainer

const CAT_ITEM = preload("res://components/selector_items/catItem.tscn")

func _on_new_pressed():
	var item = CAT_ITEM.instantiate()
	v_box_container.add_child(item)
	v_box_container.move_child(item, v_box_container.get_child_count() - 2)


func _on_close_pressed():
	var length = v_box_container.get_child_count()
	if length > 1:
		var cat_data = PackedStringArray([])
		var adv_data = PackedStringArray([])
		for n in length - 1:
			cat_data.append(v_box_container.get_child(n).displayName)
			cat_data.append(v_box_container.get_child(n).className)
			cat_data.append(v_box_container.get_child(n).resource)
			adv_data.append(v_box_container.get_child(n).selected_model)
			adv_data.append(v_box_container.get_child(n).exception_selection)
			adv_data.append(v_box_container.get_child(n).exception_texture)
			adv_data.append(v_box_container.get_child(n).special_class)
		get_parent().set_meta("data", cat_data)
		get_parent().set_meta("adv", adv_data)
		queue_free()
	else:
		queue_free()


func load_data(data, data_adv):
	var length = data.size()
	if length > 0:
		length = length/3
		for n in length:
			var item = CAT_ITEM.instantiate()
			v_box_container.add_child(item)
			v_box_container.move_child(item, v_box_container.get_child_count() - 2)
			item.load_data(data[3*n], data[(3*n)+1], data[(3*n)+2])
			item.load_data_adv(data_adv[4*n], data_adv[(4*n)+1], data_adv[(4*n)+2], data_adv[(4*n)+3])
