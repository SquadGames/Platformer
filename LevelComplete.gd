extends Control

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	print($CenterContainer/VBoxContainer/MainMenu.destination)
	$CenterContainer/VBoxContainer/MainMenu.connect(
		"pressed",
		self,
		"main_menu",
		[$CenterContainer/VBoxContainer/MainMenu.destination]
	)


func main_menu(dest):
	get_tree().change_scene(dest)


func _input(event):
	if event.is_action_pressed("start") and visible:
		main_menu("res://MainMenu.tscn")
