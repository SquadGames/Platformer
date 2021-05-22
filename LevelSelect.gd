extends Control

var LevelRow = preload("res://LevelRow.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	$BackButton.connect("pressed", self, "_load_scene", [$BackButton.destination])
	$getWorld.connect("request_completed", self, "_on_world_request_completed")
	$getWorld.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/worlds/default_world.json")

func _on_world_request_completed(result, response_code, headers, body):
	print("get selected world request complete", result)
	var text = body.get_string_from_utf8()
	var world = JSON.parse(text).result
	for level in world["levels"]:
		var level_row = LevelRow.instance()
		var button = level_row.get_child(0)
		var rating = level_row.get_child(1).get_child(0)
		button.text = level
		button.type = "scene"
		var destination = "res://placeholder.tscn"
		# button.connect("pressed", self, "_load_scene", [destination])
		rng.randomize()
		rating.label_text = str(rng.randi_range(0, 1000))
		$LevelList/LevelBox.add_child(level_row)

func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

