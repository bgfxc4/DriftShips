extends Node

export(Array, PackedScene) var modules

var next_module_pos = 130
var last_spawned_module

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_module():
	spawn_module_pos(next_module_pos)
	next_module_pos -= 140

func spawn_module_pos(z):
	var module = modules[randi() % len(modules)].instance()
	module.translation.z = z
	module.last_module = last_spawned_module
	last_spawned_module = module
	add_child(module)

	module.spawn_enemy()
