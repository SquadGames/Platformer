extends Control


func _ready():
	$BackButton.connect("pressed", self, "back", [$BackButton.destination])


func back(dest):
	get_tree().change_scene(dest)
