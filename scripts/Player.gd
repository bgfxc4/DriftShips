extends KinematicBody

signal game_over_signal(code)

var steer = 0 #-1 for left, 1 for right
export var max_turn_speed = 1
var turn_speed = 0
export var move_speed = 1
var is_game_over = false
var fuel_loss_rate = 1

var fuel = 100

func _ready():
	pass

func _process(delta):
	if !is_game_over:
		# turn the ship
		if steer == 0 && ((turn_speed > 0 && (turn_speed - 1000 * delta) < 0) || (turn_speed < 0 && (turn_speed + 1000 * delta) > 0)):
			turn_speed = 0
		elif turn_speed > steer * max_turn_speed:
			turn_speed -= 1000 * delta
		elif turn_speed < steer * max_turn_speed:
			turn_speed += 1000 * delta

		rotation_degrees = Vector3(0, fmod(rotation_degrees.y + delta * -turn_speed, 360), 0)

		# tilting the ship as its drifting
		if $main_ship.rotation_degrees.x > steer * 20:
			$main_ship.rotation_degrees -= Vector3(40 * delta, 0, 0)
		elif $main_ship.rotation_degrees.x < steer * 20:
			$main_ship.rotation_degrees += Vector3(40 * delta, 0, 0)
		
		# move the ship and check for collision		
		var col = move_and_collide(Vector3(0, 0, -move_speed * delta).rotated(Vector3(0, 1, 0), deg2rad(rotation_degrees.y + steer * 45)))
		if col:
			if col.collider.is_in_group("obstacle"):
				explode(col.position)
				game_over(get_tree().get_root().get_child(0).GAME_OVER_CODES.obstacle_col)
			elif col.collider.is_in_group("Enemy"):
				if col.local_shape.name == "CollisionShapeBack" && steer != 0:
					col.collider.queue_free()
					col.collider.collision_launch(col)
					get_tree().get_root().get_child(0).destroyed_enemy()
				else:
					explode(col.position)
					col.collider.collision(col)
					game_over(get_tree().get_root().get_child(0).GAME_OVER_CODES.enemy_col)

		# enable or disable drifting particles
		if steer == 1:
			$DriftRightParticles.emitting = false
			$DriftLeftParticles.emitting = true
		elif steer == -1:
			$DriftRightParticles.emitting = true
			$DriftLeftParticles.emitting = false
		else:
			$DriftRightParticles.emitting = false
			$DriftLeftParticles.emitting = false
				
		fuel -= (fuel_loss_rate * delta) * 4
		get_node("/root/Main/HUD").set_fuel_bar(fuel)
		
		if fuel <= 0:
			game_over(get_tree().get_root().get_child(0).GAME_OVER_CODES.no_fuel)
		
	else:
		$DriftRightParticles.emitting = false
		$DriftLeftParticles.emitting = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.position.x > (get_viewport().size.x / 2):
				steer = 1
			else:
				steer = -1
		else:
			steer = 0
	elif event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				steer = -1
			elif event.scancode == KEY_RIGHT:
				steer = 1
		else:
			steer = 0

func explode(pos):
	$ExplosionParticles.global_transform.origin = pos
	$FireParticles.global_transform.origin = pos
	$ExplosionParticles.emitting = true
	$FireParticles.emitting = true

func game_over(code):
	is_game_over = true
	emit_signal("game_over_signal", code)

func _on_VisibilityNotifier_camera_exited(camera):
	if is_game_over || get_tree() == null || !is_instance_valid(get_tree()): return
	game_over(get_tree().get_root().get_child(0).GAME_OVER_CODES.exited_screen)
