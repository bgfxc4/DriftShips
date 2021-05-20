extends Spatial

func _ready():
	#$Enemy.set_target($module_1, Vector3(58, 0.8, 55))
	$ModuleSpawner.spawn_module_pos(-50)
	$ModuleSpawner.spawn_module_pos(-350)
	$ModuleSpawner.spawn_module_pos(100)
	#$ModuleSpawner.spawn_module_pos(-180)
	#get_tree().call_group("Enemy", "set_target", $ModuleSpawner.last_spawned_module, Vector3(0, 0, 0))
	#$ModuleSpawner.last_spawned_module.spawn_enemy()
