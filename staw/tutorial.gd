extends Control


func _on_next_pressed():
	global.profile = {
		"userName" : $"NamePicker/SigningBox/NameInputer".text,
		"day" : 0,
		"stocks" : global.Industries,
		"events" : eventController.availableEvents,
		"pendingEvents" : eventController.pendingEvents,
		"happeningEvents" : eventController.happeningEvents
	}
	returnToMenu()
	
func returnToMenu():
	$"../MainMenu".visible = true
	visible = false
