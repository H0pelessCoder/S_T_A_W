extends Button

@onready
var MainMenu = $"../../MainMenu"

func _on_pressed():
	self.get_parent().visible = false
	MainMenu.visible = true
	
