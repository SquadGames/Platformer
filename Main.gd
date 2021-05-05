extends Node2D

const CONTENT_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/{level_name}.tscn"
var selected_level = "user://selectedLevel.tscn"
var level_names = ["Level_A", "Level_B"]
var i = 1

func _ready():
	i += 1
	get_and_load_level(level_names[i % 2])


func get_and_load_level(level_name):
	$HTTPRequest.request(CONTENT_ADDRESS_TEMPLATE.format({"level_name": level_name}))

# warning-ignore:unused_argument
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	# load the selected level
	var scene = load(selected_level).instance()
	add_child(scene)
	$Player.set_level_loaded(true)


# Player fell off the world
# warning-ignore:unused_argument
func _on_FallZone_body_entered(body):
	# TODO check that body is the player
	# restart the level
	print("fallzone")
	get_tree().change_scene("res://main.tscn")

