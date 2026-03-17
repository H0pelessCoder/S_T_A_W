extends Control


func _on_next_pressed():
	var dateDict = Time.get_datetime_dict_from_system()
	var dateString = str(dateDict["month"]) + "/" + str(dateDict["day"]) + "/" + str(dateDict["year"])
	global.profile = {
		"userName" : $"NamePicker/SigningBox/NameInputer".text,
		"day" : 0,
		"money" : 0,
		"date" : dateString,
		"stocks" : global.Industries,
		"events" : eventController.availableEvents,
		"pendingEvents" : eventController.pendingEvents,
		"happeningEvents" : eventController.happeningEvents
	}
	returnToMenu()
	
func returnToMenu():
	$"../MainMenu".visible = true
	visible = false
