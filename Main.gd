extends Node2D

const LEVEL_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/{level_name}.tscn"
const WORLD_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/worlds/{world_name}.json"
var starting_player_position = Vector2(0, 0)
var selected_level = "user://selectedLevel.tscn"
var loaded_level
var paused = true

func _ready():
	$Player.visible = false
	get_and_load_world("default_world")
	pause_game()


func get_and_load_world(world_name):
	$getSelectedWorld.request(WORLD_ADDRESS_TEMPLATE.format({"world_name": world_name}))


func get_and_load_level(level_name):
	var dir = Directory.new()
	dir.remove(selected_level)
	$Player.visible = false
	$getSelectedLevel.request(LEVEL_ADDRESS_TEMPLATE.format({"level_name": level_name}))


func _on_getSelectedWorld_request_completed(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	var world = JSON.parse(text).result
	for level in world["levels"]:
		var level_button = Button.new()
		level_button.text = level
		level_button.connect("button_up", self, "get_and_load_level", [level])
		$GUI/VBoxContainer.add_child(level_button)


# warning-ignore:unused_argument
func _on_getSelectedLevel_request_completed(result, response_code, headers, body):
	# load the selected level
	remove_child(loaded_level)
	loaded_level = load(selected_level).instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true
	unpause_game()


func pause_game():
	paused = true
	$Player.set_paused(true)
	$GUI.raise()
	print($Player/Camera2D.global_position)
	var camera_position = $Player/Camera2D.get_camera_position()
	$GUI.rect_position.x = camera_position.x - 320
	$GUI.rect_position.y = camera_position.y - 180
	$GUI.visible = true


func unpause_game():
	paused = false
	$Player.set_paused(false)
	$GUI.visible = false

func _input(event):
	if event.is_action_pressed("start"):
		if paused:
			unpause_game()
		else:
			pause_game()

