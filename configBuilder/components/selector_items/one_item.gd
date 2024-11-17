extends HBoxContainer

var item_data : String = ""

func _on_button_pressed():
	queue_free()


func _on_line_edit_text_changed(new_text):
	item_data = new_text

func load_data(data):
	$LineEdit.text = data
	item_data = data
