extends Node2D

var starting_player_position = Vector2(0, 0)
var loaded_level = null


func _ready():
	loaded_level = load(Singleton.selected_level).instance()
	if loaded_level.has_method("goal_areas"):
		for goal_area in loaded_level.goal_areas():
			goal_area.connect("body_entered", self, "_on_goal_entered")
	add_child(loaded_level)
	$Player.position = starting_player_position
	$Player.visible = true
	get_tree().paused = false
	Singleton.game_state = Singleton.PLAYING


func _on_FallZone_body_entered(body):
	Singleton.game_state = Singleton.DIED
	get_tree().paused = true
	$CanvasLayer/DiedMessage.visible = true
	$CanvasLayer/DiedMessage.raise()
	$LevelRestartTimer.start(1)

func _on_LevelRestartTimer_timeout():
	$CanvasLayer/DiedMessage.visible = false
	$CanvasLayer/DiedMessage.raise()
	remove_child(loaded_level)
	_ready()


func _on_goal_entered(body):
	if body == $Player:
		Singleton.game_state = Singleton.WON
		get_tree().paused = true
		$CanvasLayer/LevelComplete.visible = true
		$CanvasLayer/LevelComplete.raise()
