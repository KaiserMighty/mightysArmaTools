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
		Global.save_path = path
		Global.saveData(Global.file_extension)
		Global.save_file.close()


func _on_load_dialog_file_selected(path):
	Global.save_file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.file_exists(path):
		file_path.text = path
		Global.save_path = path
		Global.loadData(Global.file_extension)
		Global.save_file.close()


func _on_save_button_pressed():
	if FileAccess.file_exists(Global.save_path):
		Global.save_file = FileAccess.open(Global.save_path, FileAccess.WRITE)
		Global.saveData(Global.file_extension)
		Global.save_file.close()
	else:
		save_dialog.filters = PackedStringArray([Global.file_extension])
		load_dialog.filters = PackedStringArray([Global.file_extension])
		save_dialog.visible = true


func _on_load_button_pressed():
	save_dialog.filters = PackedStringArray([Global.file_extension])
	load_dialog.filters = PackedStringArray([Global.file_extension])
	load_dialog.visible = true


func _on_saveas_button_pressed():
	save_dialog.filters = PackedStringArray([Global.file_extension])
	load_dialog.filters = PackedStringArray([Global.file_extension])
	save_dialog.visible = true
