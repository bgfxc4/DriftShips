extends CanvasLayer

signal restart_game

func _ready():
	pass


func set_score(score):
	$ScoreLabel.text = str(score)

func game_over():
	$DeathScreen.visible = true

func _on_RestartButton_pressed():
	emit_signal("restart_game")