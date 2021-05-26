extends Node

enum {INITIAL, MENU, PLAYING, DIED, WON}

var selected_level = "user://selectedLevel.tscn"
var local_level_path = "res://levels/local_testing/test_level.tscn"
var game_state = self.INITIAL
