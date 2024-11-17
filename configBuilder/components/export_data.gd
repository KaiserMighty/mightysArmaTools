extends Window


func load_data(data):
	$VBoxContainer/TextEdit.text = data


func _on_button_pressed():
	queue_free()
