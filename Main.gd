extends Node2D

const CONTENT_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/{level_name}.tscn"
var selected_level = "user://selectedLevel.tscn"
var level_names = ["Level_A", "Level_B"]
var i = 1
var loaded_level

func _ready():
	print(i, level_names[i % 2])
	get_and_load_level(level_names[i % 2])


func get_and_load_level(level_name):
	var dir = Directory.new()
	dir.remove(selected_level)
	$HTTPRequest.request(CONTENT_ADDRESS_TEMPLATE.format({"level_name": level_name}))

# warning-ignore:unused_argument
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	# load the selected level
	remove_child(loaded_level)
	loaded_level = load(selected_level).instance()
	add_child(loaded_level)
	$Player.set_level_loaded(true)


# Player fell off the world
# warning-ignore:unused_argument
func _on_FallZone_body_entered(body):
	# TODO check that body is the player
	# restart the level
	$Player.set_level_loaded(false)
	i += 1 # switch to the next level
	$Player.position = Vector2(0, 0)
	_ready()

