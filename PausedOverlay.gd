extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$CenterContainer/VBoxContainer/QuitButton.connect(
		"pressed", self, "quit", [
			$CenterContainer/VBoxContainer/QuitButton.destination
		]
	)


func _input(event):
	print(event)
	if not event.is_action_pressed("start"):
		return
	raise()
	visible = not visible
	get_tree().paused = not get_tree().paused


func quit(dest):
	get_tree().change_scene("res://MainMenu.tscn")
	print(get_tree().root.get_children()[0].get_children())
