@icon("impl_icon.svg")
class_name FunctionImpl
extends Resource

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
		var gdscript:=GDScript.new()
		gdscript.source_code=decrypted.get_string_from_utf8()
		gdscript.reload()
		_obj.set_script(gdscript)


func call_impl(method:StringName,this:Object=null,args=null):
	return _obj.call(method,this,args)
