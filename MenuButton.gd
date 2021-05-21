extends Button

export(String) var type
export(String) var destination
var dynamic_font = get("custom_fonts/font")

func _ready():
	self.connect("mouse_entered", self, "_select")
	self.connect("mouse_exited", self, "_unselect")

func _select():
	dynamic_font.size = 48
	dynamic_font.outline_size = 20
	
func _unselect():
	dynamic_font.size = 32
	dynamic_font.outline_size = 0
