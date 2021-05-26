extends Control

func _ready():
	if OS.has_feature("editor"):
		$TestLocalLevel.visible = true
		$TestLocalLevel.connect(
			"pressed",
			self,
			"test_local_level",
			[$TestLocalLevel.destination]
		)


func _input(event):
	if Input.is_action_pressed("start"):
		get_tree().change_scene("res://Controls.tscn")


func test_local_level(dest):
	var dir = Directory.new()
	if dir.open(Singleton.local_level_path) != OK:
		return
	dir.list_dir_begin(true, true)
	var local_level = dir.get_next()
	if local_level.ends_with(".tscn"):
		Singleton.selected_level = Singleton.local_level_path + local_level
		get_tree().change_scene(dest)
	else:
		print("ERR: put a single local testing level in ", Singleton.local_level_path)
