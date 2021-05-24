extends Node

enum GAME_OVER_CODES {
	enemy_col,
	obstacle_col,
	exited_screen
}

export var distance_per_point = 100

var min_cam_pos
var cam_player_offs
var dist_to_next_point = 50
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	min_cam_pos = $Camera.translation.z
	cam_player_offs = $Player.translation.z - $Camera.translation.z

	$ModuleSpawner.spawn_module()
	$ModuleSpawner.spawn_module()
	$ModuleSpawner.spawn_module()

func _process(delta):
	$Camera.translation = Vector3($Camera.translation.x, $Camera.translation.y, min_cam_pos)
	if ($Player.translation.z - cam_player_offs) < min_cam_pos:
		dist_to_next_point -= min_cam_pos - $Player.translation.z # subtracting the progress of the cam
		min_cam_pos = $Player.translation.z - cam_player_offs
		if dist_to_next_point <= 0:
			increase_score(1)
	
func increase_score(val):
	score += val
	$HUD.set_score(score)
	dist_to_next_point = distance_per_point

func destroyed_enemy():
	increase_score(20)

func _on_Player_game_over_signal(code):
	$HUD.game_over(code)

func restart_game():
	get_tree().reload_current_scene()

func _on_HUD_restart_game():
	restart_game()
