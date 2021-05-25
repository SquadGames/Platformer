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
	var local_level = ""
	if dir.open(Singleton.local_level_path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		if not dir.current_is_dir():
			local_level = file_name
		dir.list_dir_end()
	if local_level != "":
		Singleton.selected_level = "res://levels/local_testing/unnamed_goose_level.tscn"
		get_tree().change_scene(dest)
	else:
		print("ERR: put a single local testing level in ", Singleton.local_level_path)
