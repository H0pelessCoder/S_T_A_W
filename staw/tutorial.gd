extends Control

#connects to a function in MainMenu called 
#save
signal save 

#connects to a function in MainMenu called 
#newGame
signal newGame

#instantiates a new profile
func beginGame():
	#gets the current date as a string
	var dateDict = Time.get_datetime_dict_from_system()
	var dateString = str(dateDict["month"]) + "/" + str(dateDict["day"]) + "/" + str(dateDict["year"])
	global.News = {}
	global.Industries = {}
	global.instantiateIndustries()
	global.instantiateNews()
	global.profile = {
		"userName" : $"NamePicker/SigningBox/NameInputer".text,
		"day" : 0,
		"money" : 0,
		"date" : dateString,
		"stocks" : global.Industries,
		"quota" : 0,
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


#from the name picking screen to the contract signing screen
func _to_contract() -> void:

	$NamePicker.visible = false
	$Contract.visible = true
	$NamePicker/Next.visible = false
	var userName = $NamePicker/SigningBox/NameInputer.text
	userName = userName.strip_edges()
	var text = $Contract/Legalese1
	text.text = text.text.replace("THEEMPLOYEEREPLACETHIS", userName)
	$Contract/SigningBox/Signature.text = userName

 #fromt he contract screen to the email screen
func _on_exit_pressed() -> void:
	$Contract.visible = false
	$EmailScreen.visible = true
	pass # Replace with function body.

#from the email screen to the new game
func _on_email_exit_pressed() -> void:
	$EmailScreen.visible = false
	$EmailScreen/TextViewer.visible = false
	$EmailScreen/Email.visible = true
	$NamePicker.visible = true
	$Contract/Legalese1.visible = true
	$Contract/Legalese4.visible = false
	$Contract/SigningBox.visible = false
	$Contract/EmployerSignature.visible = false
	$Contract/SigningBox/Signature.visible_ratio = 0
	$Contract/NextPage.visible = true
	$Contract/Exit.visible = false
	$EmailScreen/EmailExit.visible = false
	visible = false
	beginGame()

#from the email screen to the email text
func _on_mail_selector_pressed() -> void:
	$EmailScreen/Email.visible = false
	$EmailScreen/TextViewer.visible = true
	$EmailScreen/EmailExit.visible = true
	
