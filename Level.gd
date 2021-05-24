extends Node2D

var starting_player_position = Vector2(0, 0)
var loaded_level = null


func _ready():
	var loaded_level = load("user://selectedLevel.tscn").instance()
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true


func _on_FallZone_body_entered(body):
	raise()
	$Player.set_paused(true)
	$CanvasLayer/DiedMessage.visible = true
	$LevelRestartTimer.start(2)


func _on_LevelRestartTimer_timeout():
	$CanvasLayer/DiedMessage.visible = false
	remove_child(loaded_level)
	_ready()
