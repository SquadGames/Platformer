extends Node2D

export(String) var level

var starting_player_position = Vector2(0, 0)
var loaded_level = null


func _ready():
	print("Trying to load ", level)
	loaded_level = load(level).instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true
	$Player.set_paused(false)


func _on_FallZone_body_entered(body):
	raise()
	$Player.set_paused(true)
	$CanvasLayer/DiedMessage.visible = true
	$LevelRestartTimer.start(2)


func _on_LevelRestartTimer_timeout():
	$CanvasLayer/DiedMessage.visible = false
	remove_child(loaded_level)
	_ready()
