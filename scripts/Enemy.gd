extends KinematicBody

var path = []
var path_node = 0

var speed = 10
var current_nav = null
var current_target_pos
var moving = false

func _ready():
	pass

func _physics_process(delta):
	if path_node < path.size():
		var direction = (current_nav.translation + path[path_node] - translation)
		if direction.length() < 1:
			path_node += 1
			if path_node >= path.size():
				moving = false
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func set_target(nav, target_pos):
	moving = true
	current_nav = nav
	current_target_pos = target_pos
	path = nav.get_simple_path(translation - current_nav.translation, target_pos)
	path_node = 0
	print("current pos: ", translation, " target pos: ", target_pos, " pos of nav: ", nav.transform.origin, " path length: ",  path.size(), " path: ", path)
	#debug_mark_path()

func _on_VisibilityNotifier_screen_exited():
	queue_free()

func _on_Timer_timeout():
	if current_nav == null || !moving: return
	#set_target(current_nav, Vector3(global_transform.origin.x, current_target_pos.y, current_target_pos.z))

func debug_mark_path():
	var marker = load("res://scenes/TestScenes/TestMarker.tscn")
	var marker_instance = marker.instance()
	get_parent().get_parent().add_child(marker_instance)
	marker_instance.translation = translation - current_nav.translation + current_nav.translation
	# for node in path:
	# 	marker_instance = marker.instance()
	# 	get_parent().get_parent().add_child(marker_instance)
	# 	marker_instance.translation = current_nav.translation + node
