extends KinematicBody

var path = []
var path_node = 0

var speed = 20
var current_nav = null
var current_target_pos
var moving = false
var dead = false

onready var dead_enemy_scene = load("res://scenes/DeadEnemy.tscn")

func _ready():
	pass

func _physics_process(delta):
	if path_node < path.size() && !dead:
		if current_nav == null || !is_instance_valid(current_nav):
			queue_free()
			return
		
		var direction = (current_nav.translation + path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
			if path_node >= path.size():
				moving = false
				if current_nav.last_module != null:
					set_target(current_nav.last_module, Vector3(0, 0, 70))
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			# global_transform.origin += direction.normalized() * speed * 0.02
			look_at(current_nav.translation + path[path_node], Vector3.UP)

func set_target(nav, target_pos):
	if nav == null || !is_instance_valid(nav): 
		queue_free()
		return

	moving = true
	current_nav = nav
	current_target_pos = target_pos
	path = nav.get_simple_path(translation - current_nav.translation, target_pos)
	path_node = 0

func collision(col):
	dead = true
	
func collision_launch(col):
	var instance = dead_enemy_scene.instance()
	instance.transform = transform
	get_parent().add_child(instance)
	instance.launch(col.position, (col.normal * Vector3(-1, 1, -1)))

func _on_VisibilityNotifier_screen_exited():
	queue_free()

func debug_mark_path():
	var marker = load("res://scenes/TestScenes/TestMarker.tscn")
	var marker_instance = marker.instance()
	get_parent().get_parent().add_child(marker_instance)
	marker_instance.translation = translation - current_nav.translation + current_nav.translation
	for node in path:
		marker_instance = marker.instance()
		get_parent().get_parent().add_child(marker_instance)
		marker_instance.translation = current_nav.translation + node
