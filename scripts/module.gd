extends Spatial


func _ready():
	pass

func _on_VisibilityNotifier_screen_exited():
	get_parent().spawn_module()
	queue_free()
