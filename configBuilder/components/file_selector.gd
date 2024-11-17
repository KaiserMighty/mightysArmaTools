extends Control

@onready var save_dialog = $SaveDialog
@onready var load_dialog = $LoadDialog
@onready var file_path = $HBoxContainer/FilePath


func _ready():
	save_dialog.current_dir = "/"
	load_dialog.current_dir = "/"
	save_dialog.filters = PackedStringArray([Global.file_extension])
	load_dialog.filters = PackedStringArray([Global.file_extension])


func _on_save_dialog_file_selected(path):
	Global.save_file = FileAccess.open(path, FileAccess.WRITE)
	if FileAccess.file_exists(path):
		file_path.text = path
		Global.save_file.store_line(JSON.stringify(Global.data))


func _on_load_dialog_file_selected(path):
	var load_file = FileAccess.open(path, FileAccess.READ)
	file_path.text(path)
	if FileAccess.file_exists(path):
		Global.data = JSON.parse_string(load_file.get_line())


func _on_save_button_pressed():
	if Global.save_file != null:
		Global.save_file.store_line(JSON.stringify(Global.data))
	else:
		save_dialog.visible = true


func _on_load_button_pressed():
	load_dialog.visible = true


func _on_saveas_button_pressed():
	save_dialog.visible = true
