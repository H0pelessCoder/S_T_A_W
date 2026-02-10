extends Button
@onready
var main = "../../" 
@onready
var settings = "../"

func _on_pressed():
	self.get_parent().visible = false
	var meta = get_node(settings).get_meta("LastOpen")
	var path = main + meta
	get_node(path).visible = true
	
