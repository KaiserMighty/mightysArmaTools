extends Window

@onready var textbox = $VBoxContainer/TextEdit

const CfgPatches : String = """class CfgPatches
{
	class {title}
	{
		version="0.1";
		units[]={};
		weapons[]={};
		requiredVersion="0.1";
		requiredAddons[]={};
	};
};"""

const CfgWeaponEntry : String = """class {class_prefix}{class_name}_U: {inherit}
	{
		scope=2;
		scopeArsenal=2;
		author="{author}";
		displayName="{display_prefix}{display_name}";
		picture="{picture}";
		model="\\A3\\Characters_F\\Common\\Suitpacks\\suitpack_blufor_diver";
		class ItemInfo: UniformItem
		{
			uniformModel="-";
			uniformClass="{class_prefix}({class_name})";
			containerClass="Supply50";
			mass=5;
			allowedSlots[]={"701","801","901"};
			armor=0;
		};
		class XtdGearInfo
		{
			model="{class_prefix}_UNIFORM";
			top="rbls";
			style="tucked";
			gloves="none";
		};
	};"""

func load_data(data):
	if Global.file_extension == "*.cfgu":
		export_uniforms(data)


func _on_close_button_pressed():
	queue_free()


func _on_copy_button_pressed():
	DisplayServer.clipboard_set($VBoxContainer/TextEdit.text)


func export_uniforms(data):
	var export : String = ""
	
	export += CfgPatches.format({"title": data.patches_title})
	
	for n in data.base_inheritance.size():
		export += "\nclass {base_class};".format({"base_class": data.base_inheritance[n]})
	
	export += "\nclass CfgWeapons\n{"
	
	for n in data.weapon_inheritance.size():
		export += "\n	class {weapon_class};".format({"weapon_class": data.weapon_inheritance[n]})
	
	for n in data.category_data.size():
		export += """\n	{category}="{category}";""".format({"category": data.category_data[n]["cat_title"]})
	
	export += "\n}\n"
	
	textbox.text = export
