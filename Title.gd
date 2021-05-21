extends Control

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("start"):
		get_tree().change_scene("res://MainMenu.tscn")
