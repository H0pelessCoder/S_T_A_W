extends Button




func _on_pressed():
	$"../SigningBox/NameInputer".text = ""
	$"../../".visible = false
	$"../../../MainMenu".visible = true
