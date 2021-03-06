extends CanvasLayer

signal restart_game

func _ready():
	pass


func set_score(score):
	$ScoreLabel.text = str(score)

func set_fuel_bar(percent):
	$"FuelBarParent/FuelBar".value = percent

func game_over(code):
	$DeathScreen.visible = true
	set_hint_text(game_over_code_to_text(code))
	
func set_hint_text(text):
	$Hint.visible = true
	$Hint.text = "Hint:\n" + text

func game_over_code_to_text(code):
	if get_tree() == null: return "An Error occured"
	var main = get_tree().get_root().get_child(0)
	if code == main.GAME_OVER_CODES.enemy_col:
		return "Use the back part of your ship while drifting to destroy enemies."
	elif code == main.GAME_OVER_CODES.obstacle_col:
		return "Don't crash into the obstacles."
	elif code == main.GAME_OVER_CODES.exited_screen:
		return "Don't leave the screen."
	elif code == main.GAME_OVER_CODES.no_fuel:
		return "Collect fuel cans to not run out of fuel."
	else:
		return ""

func _on_RestartButton_pressed():
	emit_signal("restart_game")
