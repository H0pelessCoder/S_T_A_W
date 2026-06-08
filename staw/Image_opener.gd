extends Button

#opens the given tutorial
func _on_pressed(imageName: String) -> void:
	get_node("../../" + imageName + "Viewer").visible = true
	$"..".visible = false
	$"../../EmailExit".visible = false
