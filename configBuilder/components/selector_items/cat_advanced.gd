extends Window

@onready var models = $VBoxContainer/Models
@onready var hidden_selection = $VBoxContainer/hiddenSelection
@onready var hidden_selection_texture = $VBoxContainer/hiddenSelectionTexture
@onready var special_class = $VBoxContainer/specialClass


func _on_close_pressed():
	get_parent().set_meta("exception_upper", hidden_selection.text)
	get_parent().set_meta("exception_lower", hidden_selection_texture.text)
	get_parent().set_meta("special", special_class.text)
	if models.selected > 0:
		get_parent().set_meta("model", models.get_item_text(models.selected))
	else:
		get_parent().set_meta("model", "")
	queue_free()

func load_data(selected_model, exception_selection, exception_texture, special):
	hidden_selection.text = exception_selection
	hidden_selection_texture.text = exception_texture
	special_class.text = special
	for n in Global.ownerNode.models.size():
		models.add_item(Global.ownerNode.models[n])
		if selected_model == Global.ownerNode.models[n]:
			models.select(n+1)
