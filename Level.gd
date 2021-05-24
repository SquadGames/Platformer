extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var level
var starting_player_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Trying to load ", level)
	var loaded_level = load(level).instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FallZone_body_entered(body):
	pass # Replace with function body.
