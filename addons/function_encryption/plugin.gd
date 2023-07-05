@tool
extends EditorPlugin

var import_plugin:EditorImportPlugin=preload("impl_importer.gd").new()
const _key_location:String="res://secret"
var _key_length:int


func _enter_tree():
	add_import_plugin(import_plugin)
	if !ProjectSettings.has_setting("function_encryption/key_length"):
		ProjectSettings.set_setting("function_encryption/key_length",4096)
	_key_length=ProjectSettings.get_setting("function_encryption/key_length")
	var dir:=DirAccess.open("res://secret")
	if dir==null or !dir.file_exists("id_rsa.pub") or !dir.file_exists("id_rsa.key"):
		_generate_key()
	project_settings_changed.connect(_on_project_settings_changed)


func _generate_key():
	if !DirAccess.dir_exists_absolute(_key_location):
		DirAccess.make_dir_recursive_absolute(_key_location)
	else:
		var dir:=DirAccess.open(_key_location)
		dir.remove("id_rsa.key")
		dir.remove("id_rsa.pub")
	var crypto:=Crypto.new()
	var key:=crypto.generate_rsa(_key_length)
	key.save(_key_location.path_join("id_rsa.key"),false)
	key.save(_key_location.path_join("id_rsa.pub"),true)


func _search_recursive(path:String)->PackedStringArray:
	var files:=PackedStringArray()
	var dir:=DirAccess.open(path)
	if dir==null:
		return []
	dir.list_dir_begin()
	var name:=dir.get_next()
	while name!="":
		if dir.current_is_dir():
			files.append_array(_search_recursive.call(name))
		elif name.ends_with(".impl"):
			files.push_back(name)
		name=dir.get_next()
	dir.list_dir_end()
	return files


func _on_project_settings_changed():
	if _key_length!=ProjectSettings.get_setting("function_impl/key_length"):
		_generate_key()
		get_editor_interface().get_resource_filesystem().reimport_files(_search_recursive("res://"))


func _exit_tree():
	remove_import_plugin(import_plugin)
