extends RichTextLabel

export(String) var label_text

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.bbcode_text = "[right]%s[/right]" % label_text

