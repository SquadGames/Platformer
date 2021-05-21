extends Control

var RatingLabel = preload("res://RatingLabel.tscn")
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
		var level_button = Button.new()
		level_button.text = level
		# level_button.connect("button_up", self, "get_and_load_level", [level])
		$Levels.add_child(level_button)
		var level_rating = RatingLabel.instance()
		rng.randomize()
		level_rating.label_text = str(rng.randi_range(0, 10000))
		print("trying to add level rating", level_rating.text)
		$Ratings.add_child(level_rating)

func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

