extends Button

export(String) var type
export(String) var destination
export(int) var font_size = 32
export(int) var selected_font_size = 48
export(int) var selected_outline_size = 20
var dynamic_font = DynamicFont.new()

func _ready():
	dynamic_font.font_data = load("res://assets/GUI/Fonts/Pangolin-Regular.ttf")
	dynamic_font.size = font_size
	self.set("custom_fonts/font", dynamic_font)
	self.connect("mouse_entered", self, "_select")
	self.connect("mouse_exited", self, "_unselect")

func _select():
	dynamic_font.size = selected_font_size
	dynamic_font.outline_size = selected_outline_size
	
func _unselect():
	dynamic_font.size = font_size
	dynamic_font.outline_size = 0
