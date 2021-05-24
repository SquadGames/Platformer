extends Control

export(String) var level
export(String) var level_name
export(String) var author
export(String) var current_owner

var level_URI = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/%s.tscn"
var Level = preload("res://Level.tscn")
var _level = Level.instance()

func _ready():
	$get_level.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/%s.tscn" % level_name)
	$MainColumn/TitleRow/SupportBox/SupportButton.connect(
		"pressed", 
		self, 
		"_load_scene", 
		[$MainColumn/TitleRow/SupportBox/SupportButton.destination]
	)
	$MainColumn/BackButton.connect(
		"pressed", 
		self, 
		"_load_scene", 
		[$MainColumn/BackButton.destination]
	)
	$MainColumn/TitleRow/TitleBox/Title.text = level_name

func _on_get_level_request_completed(result, response_code, headers, body):
	var level_data = body.get_string_from_utf8()
	_level.level = level
	$MainColumn/StartButton.connect("pressed", self, "_load_level", [_level])
	$MainColumn/Author.text = author
	$MainColumn/Patron.text = current_owner

func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)

func _load_level(_level):
	print("Trying to load level:", _level)
	get_tree().root.call_deferred("add_child", _level)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
