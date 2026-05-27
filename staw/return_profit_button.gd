extends Button

@onready
var NewsScreen = $"../../NewsMenu"
@onready
var EndScreen = $"../../EndScreen"



func _on_pressed() -> void:
	get_node("..").visible = false
	if(global.day >= global.maxDay):
		EndScreen.visible = true
		return
	NewsScreen.visible = true
	
