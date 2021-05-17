extends Node

export(Array, PackedScene) var modules

var next_module_pos = 130

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_module():
	var module = modules[randi() % len(modules)].instance()
	module.translation.z = next_module_pos
	next_module_pos -= 140
	add_child(module)
