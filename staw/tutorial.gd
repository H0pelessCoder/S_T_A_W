extends Control
signal save 
signal newGame
func _on_next_pressed():
	var dateDict = Time.get_datetime_dict_from_system()
	var dateString = str(dateDict["month"]) + "/" + str(dateDict["day"]) + "/" + str(dateDict["year"])
	eventController.availableEvents = {}
	global.instantiateNews()
	global.profile = {
		"userName" : $"NamePicker/SigningBox/NameInputer".text,
		"day" : -1,
		"money" : 0,
		"date" : dateString,
		"stocks" : global.Industries,
		"events" : eventController.availableEvents,
		"pendingEvents" : eventController.eventFormat(),
		"happeningEvents" : eventController.eventFormat(),
		"gameStarted" : false
	}
	emit_signal("save")
	visible = false
	emit_signal("newGame")
	
func returnToMenu():
	$"../MainMenu".visible = true
	visible = false
