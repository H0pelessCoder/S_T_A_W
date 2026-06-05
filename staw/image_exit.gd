extends Button



func _on_pressed() -> void:
	$"..".visible = false
	$"../../TextViewer".visible = true
	$"../../EmailExit".visible = true
