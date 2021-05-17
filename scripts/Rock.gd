extends Area2D

func _ready():
	var texture = load("res://assets/sprites/rocks/rock_sprite_" + str(randi() % 4 + 1) + ".png")
	$Sprite.texture = texture
	scale = Vector2(1, 1) * (0.13 + ((randi() % 5) / 10))
	hide()
	place_and_show(Vector2(50, 50))


func place_and_show(pos):
	position = pos
	show()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()