@icon("impl_icon.svg")
class_name FunctionImpl
extends Resource

var _gdscript:=GDScript.new()
var _obj:=RefCounted.new()
@export var data:Array[PackedByteArray]:
	set(array):
		data=array
		if Engine.is_editor_hint():
			return
		var decrypted:=PackedByteArray()
		var encrypted:=data
		var crypto:=Crypto.new()
		var key:=CryptoKey.new()
		key.load("res://secret/id_rsa.key",false)
		for bytes in encrypted:
			decrypted.append_array(crypto.decrypt(key,bytes))
		_gdscript.source_code=decrypted.get_string_from_utf8()
		_gdscript.reload()
		_obj.set_script(_gdscript)


func call_impl(method:StringName,this:Object=null,args=null):
	return _obj.call(method,this,args)
