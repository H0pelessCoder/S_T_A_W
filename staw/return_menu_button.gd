extends Button

@onready
var MainMenu = $"../../MainMenu"
func _on_pressed():
	print("hi")
	self.get_parent().visible = false
	MainMenu.visible = true
	
