extends Window

@onready var textbox = $VBoxContainer/TextEdit


func load_data(data):
	# textbox.text = "\n".join(data)
	if Global.file_extension == "*.cfgu":
		export_uniforms(data)


func _on_close_button_pressed():
	queue_free()


func _on_copy_button_pressed():
	DisplayServer.clipboard_set($VBoxContainer/TextEdit.text)


func export_uniforms(data):
	pass
