extends Control
class_name tutorial
static var userName

func _on_next_pressed():
	userName = $"NamePicker/SigningBox/NameInputer".text
	returnToMenu()
	
func returnToMenu():
	$"../MainMenu".visible = true
	visible = false
