extends Control
signal save 
signal newGame
func _on_next_pressed():
	var dateDict = Time.get_datetime_dict_from_system()
	var dateString = str(dateDict["month"]) + "/" + str(dateDict["day"]) + "/" + str(dateDict["year"])
	global.News = {}
	global.Industries = {}
	global.instantiateIndustries()
	global.instantiateNews()
	global.profile = {
		"userName" : $"NamePicker/SigningBox/NameInputer".text,
		"day" : -1,
		"money" : 0,
		"date" : dateString,
		"stocks" : global.Industries,
		"events" : global.News,
		"availableEvents" : eventController.availableEvents,
		"pendingEvents" : eventController.eventFormat(),
		"happeningEvents" : eventController.eventFormat(),
		"currEffects" : {}
	}
	print(global.profile["userName"])
	visible = false
	emit_signal("newGame")
	
func returnToMenu():
	$"../MainMenu".visible = true
	visible = false


func _on_next_page_pressed() -> void:
	pass # Replace with function body.


func _to_contract() -> void:
	$NamePicker.visible = false
	$Contract.visible = true
