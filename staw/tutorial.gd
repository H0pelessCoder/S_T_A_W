extends Control
signal save 
signal newGame

func beginGame():
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
	var userName = $NamePicker/SigningBox/NameInputer.text
	userName = userName.strip_edges()
	var text = $Contract/Legalese1
	text.text = text.text.replace("THEEMPLOYEEREPLACETHIS", userName)
	$Contract/SigningBox/Signature.text = userName


func _on_exit_pressed() -> void:
	$Contract.visible = false
	$EmailScreen.visible = true
	pass # Replace with function body.


func _on_email_exit_pressed() -> void:
	$EmailScreen.visible = false
	$NamePicker.visible = true
	$Contract/Legalese1.visible = true
	$Contract/Legalese4.visible = false
	$Contract/SigningBox.visible = false
	$Contract/EmployerSignature.visible = false
	$Contract/SigningBox/Signature.visible_ratio = 0
	$Contract/NextPage.visible = true
	$Contract/Exit.visible = false
	visible = false
	beginGame()


func _on_mail_selector_pressed() -> void:
	$EmailScreen/Email.visible = false
	$EmailScreen/TextViewer.visible = true
	$EmailScreen/EmailExit.visible = true
	
