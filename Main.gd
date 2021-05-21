extends Node2D

const LEVEL_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/{level_name}.tscn"
const LOCAL_LEVEL_TEMPLATE = "res://levels/{level_name}.tscn"
const WORLD_ADDRESS_TEMPLATE = "https://raw.githubusercontent.com/SquadGames/Platformer/main/worlds/{world_name}.json"
var starting_player_position = Vector2(0, 0)
var selected_level = "user://selectedLevel.tscn"
var entered_level = ""

var loaded_level
var paused = true

func _ready():
	$Player.visible = false
	pause_game()
	$GUI/VBoxContainer/HBoxContainer/LocalLevelName.connect(
		"text_changed", self, "set_entered_level"
	)
	$GUI/VBoxContainer/HBoxContainer/LocalLevelButton.connect(
		"button_up", self, "load_local_level"
	)
	$GUI/VBoxContainer/QuitButton.connect("button_up", self, "quit")
	get_and_load_world("default_world")

	# TODO make this some secret input to unlock local levels
	if !OS.has_feature("editor"):
		$GUI/VBoxContainer/HBoxContainer/LocalLevelButton.remove_and_skip()
		$GUI/VBoxContainer/HBoxContainer/LocalLevelName.remove_and_skip()


func quit():
	get_tree().quit()


func set_entered_level(text):
	entered_level = text
	print("entered ", entered_level)


func get_and_load_world(world_name):
	$getSelectedWorld.request(WORLD_ADDRESS_TEMPLATE.format({"world_name": world_name}))


func get_and_load_level(level_name, template = LEVEL_ADDRESS_TEMPLATE):
	selected_level = "user://selectedLevel.tscn"
	var dir = Directory.new()
	dir.remove(selected_level)
	$Player.visible = false
	$getSelectedLevel.request(template.format({"level_name": level_name}))


func load_local_level():
	selected_level = LOCAL_LEVEL_TEMPLATE.format({"level_name": entered_level})
	start_level()

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
	start_level()


func start_level():
	# load the selected level
	remove_child(loaded_level)
	print("loading ", selected_level)
	loaded_level = load(selected_level).instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true
	
	# Connect Goals entered signals
	if loaded_level.has_method("goal_areas"):
		for area in loaded_level.goal_areas():
			area.connect("body_entered", self, "_on_goal_body_entered")

	# Connect player to level wind
	if loaded_level.has_method("wind_areas"):
		for area in loaded_level.wind_areas():
			area.connect("body_entered", $Player, "_on_wind_body_entered", [area.wind_velocity])
			area.connect("body_exited", $Player, "_on_wind_body_exited", [area.wind_velocity])

	unpause_game()


func pause_game():
	paused = true
	$Player.set_paused(true)
	$GUI.raise()
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


func _on_FallZone_body_entered(body):
	start_level()

func _on_goal_body_entered(body):
	pause_game()

