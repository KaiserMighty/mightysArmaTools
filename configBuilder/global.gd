extends Node

var file_extension : String = "*.cfg"
var save_file : FileAccess = null
var data : Dictionary = {}

func init_globals(ext):
	file_extension = ext
	save_file = null
	data.clear()
