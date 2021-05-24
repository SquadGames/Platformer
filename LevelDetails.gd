extends Control

export(String) var level
export(String) var author
export(String) var current_owner

var Level = preload("res://Level.tscn")

func _ready():
	var _level = Level.instance()
	_level.level = level
	$MainColumn/StartButton.connect("pressed", self, "_load_level", [_level])
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
