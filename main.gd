extends Node2D

var _impl:FunctionImpl=preload("res://main.gd.impl")
var variable


func _ready():
	_impl.call_impl("_ready",self)
	print(variable)


func _process(delta):
	_impl.call_impl("_process",self,delta)
