extends Control

var LevelDetails = preload("res://LevelDetails.tscn")
var LevelRow = preload("res://LevelRow.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	$BackButton.connect("pressed", self, "_load_scene", [$BackButton.destination])
	$get_world.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/worlds/default_world.json")

func _on_get_world_request_completed(result, response_code, headers, body):
	print("get selected world request complete", result)
	var text = body.get_string_from_utf8()
	var world = JSON.parse(text).result
	for level in world["levels"]:
		print("Level:", level)
		var level_row = LevelRow.instance()
		var button = level_row.get_child(0)
		var rating = level_row.get_child(1).get_child(0)
		button.text = level
		button.type = "scene"
		var level_details = LevelDetails.instance()
		level_details.level = "res://levels/%s.tscn" % level
		level_details.level_name = level
		level_details.author = "Author: placeholder"
		level_details.current_owner = "Patron: placeholder"
		button.connect("pressed", self, "_load_details", [level_details])
		
		rng.randomize()
		rating.label_text = str(rng.randi_range(0, 1000))
		$LevelList/LevelBox.add_child(level_row)

func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)

func _load_details(level_details):
	print("Trying to load details:", level_details.level)
	get_tree().root.call_deferred("add_child", level_details)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
