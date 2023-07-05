# gdscript-function-encryption
Encrypt GDScript funcrion implementations easier  

__Note that this is not a safe way to protect your codes because .pck includes raw encryption keys.__  
__Use [pck encryption](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_with_script_encryption_key.html) if you need stronger protection.__

## Usage
External script editor is recommended. Godot editor does not recognize .impl as a text file.
1. Activate this plugin. `res://secret` and encryption keys are generated.
2. Write function definitions and variables etc... to .gd file.
`call_impl()` accepts 3 arguments: method name, object, and arguments(optional).
If you need more arguments, pass array or dictionary.
```gdscript
extends Node

var _impl:=preload("res://main.gd.impl")  # load implementation
var variable

func _ready():
    _impl.call_impl("_ready",self)


func function(greetings:String):
    _impl.call_impl("function",self,"hello")
```
3. Write function implementations to .impl files.
These scripts do not need to extend any class.
All functions must be like `function_name(this:Object,args)`.
Do not use `self` in .impl file, use `this` passed by `call_impl()` instead.
You can also use super class function by passing lambda as a argument.
```gdscript
func _ready(this:Object,_args):
    this.variable=1


func function(_this:Object,args):
    print(args)
```
4. .impl is encrypted and decrypted when loaded.
