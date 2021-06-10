extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	$BackButton.connect("pressed", self, "back", [$BackButton.destination])
	$GetContent.request("https://raw.githubusercontent.com/SquadGames/Platformer/main/docs/what_is_this.md")


func back(dest):
	get_tree().change_scene(dest)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	$Content.text = text
