extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$BackButton.connect("pressed", self, "back", [$BackButton.destination])


func back(dest):
	get_tree().change_scene(dest)
