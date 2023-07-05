extends EditorImportPlugin


func _get_importer_name()->String:
	return "impl_import.plugin"


func _get_visible_name()->String:
	return "Function Impl"


func _get_recognized_extensions()->PackedStringArray:
	return ["impl"]


func _get_save_extension()->String:
	return "res"


func _get_resource_type()->String:
	return "Resource"


func _get_import_order()->int:
	return 0


func _get_priority()->float:
	return 1.0


func _get_preset_count()->int:
	return 1


func _get_preset_name(i:int)->String:
	return "Default"


func _get_import_options(path:String,i:int)->Array[Dictionary]:
	return [{"name":"byte_length","default_value":256}]


func _get_option_visibility(path:String,option_name:StringName,options:Dictionary)->bool:
	return true


func _import(source_file:String,save_path:String,options:Dictionary,platform_variants:Array[String],gen_files:Array[String])->Error:
	var f_impl:=FileAccess.open(source_file,FileAccess.READ)
	if f_impl!=null:
		var impl:=FunctionImpl.new()
		var code_bytes:=f_impl.get_buffer(f_impl.get_length())
		var crypto:=Crypto.new()
		var key:=CryptoKey.new()
		key.load("res://secret/id_rsa.pub",true)
		var encrypted:Array[PackedByteArray]=[]
		var length:int=options["byte_length"]
		while !code_bytes.is_empty():
			encrypted.push_back(crypto.encrypt(key,code_bytes.slice(0,length)))
			code_bytes=code_bytes.slice(length)
		impl.data=encrypted
		return ResourceSaver.save(impl,save_path+"."+_get_save_extension())
	else:
		push_error("Cannot open "+source_file)
		return FAILED
