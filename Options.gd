extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$BackButton.connect("pressed", self, "_load_scene", [$BackButton.destination])


func _load_scene(dest):
	get_tree().change_scene(dest)
