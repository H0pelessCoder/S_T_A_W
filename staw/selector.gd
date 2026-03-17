extends Button

signal selectSave (String)

func _on_pressed() -> void:
	print("Pressed")
	emit_signal("selectSave", get_meta("saveName"))
