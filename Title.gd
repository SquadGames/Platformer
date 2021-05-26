extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
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
	assert(
		dir.file_exists(Singleton.local_level_path),
		"ERR: local level file not found, expecting " + Singleton.local_level_path
	)
	Singleton.selected_level = Singleton.local_level_path
	get_tree().change_scene(dest)
