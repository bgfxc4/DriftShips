extends Navigation

var last_module
var enemy = load("res://scenes/Enemy.tscn")

func _on_VisibilityNotifier_screen_exited():
	get_parent().spawn_module()
	queue_free()

func spawn_enemy():
	var instance = enemy.instance()
	get_parent().add_child(instance)
	instance.translation = translation - Vector3((randi() % 200) - 100, 0, 70)
	instance.set_target(self, Vector3((randi() % 200) - 100, 0, 70))
