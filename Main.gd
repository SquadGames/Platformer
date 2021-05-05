extends Node2D


var selected_level = "user://Level.tscn"


func _ready():
	# load the selected level
	var scene = load(selected_level).instance()
	add_child(scene)


# Player fell off the world
# warning-ignore:unused_argument
func _on_FallZone_body_entered(body):
	# TODO check that body is the player
	# restart the level
	print("fallzone")
	get_tree().change_scene("res://main.tscn")
