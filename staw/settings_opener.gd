extends Button

@onready
var Settings = $"../../Settings"

func _on_pressed():
	self.get_parent().visible = false
	Settings.visible = true
	Settings.set_meta("LastOpen", "./" + get_parent().name)
	
	
