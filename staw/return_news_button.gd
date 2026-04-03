extends Button

@onready
var NewsScreen = $"../../NewsMenu"



func _on_pressed() -> void:
	get_node("..").visible = false
	NewsScreen.visible = true
	
