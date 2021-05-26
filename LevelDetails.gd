extends Control

var selected_level = "user://selectedLevel.tscn"
var level_URI = "https://raw.githubusercontent.com/SquadGames/Platformer/main/levels/%s.tscn"
var Level = preload("res://Level.tscn")
var level = Level.instance()

func _ready():
	var dir = Directory.new()
	dir.remove(selected_level)
	$MainColumn/StartButton.connect(
		"pressed",
		self,
		"_load_scene",
		["res://Level.tscn"]
	)
	$MainColumn/TitleRow/SupportBox/SupportButton.connect(
		"pressed", 
		self, 
		"_open_link", 
		[$MainColumn/TitleRow/SupportBox/SupportButton.destination]
	)
	$MainColumn/BackButton.connect(
		"pressed", 
		self, 
		"_back"
	)

func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)
	
func _open_link(link):
	print("Trying to open link: ", link)
	OS.shell_open(link)
	
func _back():
	self.visible = false

func _start_level():
	print("Trying to load level:", level)
	get_tree().root.call_deferred("add_child", level)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
