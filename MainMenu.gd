extends Control

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	for button in $Opts.get_children():
		if button.type == "scene":
			button.connect("pressed", self, "_load_scene", [button.destination])
		elif button.type == "link":
			button.connect("pressed", self, "_open_link", [button.destination])
	
func _load_scene(scene):
	print("Trying to load scene: ", scene)
	get_tree().change_scene(scene)
	
func _open_link(link):
	print("Trying to open link: ", link)
	OS.shell_open(link)
