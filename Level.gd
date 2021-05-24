extends Node2D

var starting_player_position = Vector2(0, 0)

func _ready():
	var loaded_level = load("user://selectedLevel.tscn").instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true
	print('Level.gd ready: ', get_tree().root.get_children())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FallZone_body_entered(body):
	pass # Replace with function body.
