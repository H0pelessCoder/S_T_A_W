extends Button



func _on_pressed():
	$"../../Tutorial".visible = true
	$"../".visible = false
	$"../../Tutorial/NamePicker/SigningBox/NameInputer".text = ""
