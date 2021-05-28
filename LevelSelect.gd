extends Control

var LevelRow = preload("res://LevelRow.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$BackButton.connect("pressed", self, "_load_scene", [$BackButton.destination])
	$get_world.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/worlds/default_world.json")

func _on_get_world_request_completed(result, response_code, headers, body):
	print("get selected world request complete", result)
	var text = body.get_string_from_utf8()
	var world = JSON.parse(text).result
	for level_name in world["levels"]:
		var level_row = LevelRow.instance()
		var button = level_row.get_child(0)
		var rating = level_row.get_child(1).get_child(0)
		button.text = level_name
		button.type = "popup"
		button.connect("pressed", self, "_level_details", [level_name])
		
		rng.randomize()
		rating.label_text = str(rng.randi_range(0, 1000))
		print("rating", rating.label_text)
		$LevelList/ScrollContainer/LevelBox.add_child(level_row)
		
func _on_get_level_request_completed(result, response_code, headers, body):
	if $LevelDetails.visible:
		$LevelDetails.visible = false
	else:
		$LevelDetails.visible = true

func _load_scene(scene):
	get_tree().change_scene(scene)

func _level_details(level_name):
	$LevelDetails/MainColumn/TitleRow/TitleBox/Title.text = level_name
	$LevelDetails/MainColumn/Author.text = "Author: placeholder"
	$LevelDetails/MainColumn/Patron.text = "Patron: placeholder"
	$get_level.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/%s.tscn" % level_name)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
