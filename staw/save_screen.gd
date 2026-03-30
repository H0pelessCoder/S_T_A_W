extends Control
@onready
var saveTemplate = $"SaveSlotTemplate"
@onready
var saveSlots = $"SaveSlots"
@onready
var confirmationScreen = $"Confirmation"
signal loadGame
signal buttonPressed 
var currentSave = ""
var yesPressed = false
var noPressed = false
# Called when the node enters the scene tree for the first time.
func drawSaveScreen():
	var yesPressed = false
	var noPressed = false
	for slot in saveSlots.get_children():
		slot.free()
	var saves = preload("res://src/saves.json")
	var profileDict = saves.data
	for profile in profileDict:
		profile = profileDict[profile]
		var newProfile = saveTemplate.duplicate()
		var newProfileName = newProfile.get_child(0).get_child(0)
		var newProfileDay = newProfile.get_child(0).get_child(1)		
		var newProfileMoney = newProfile.get_child(0).get_child(2)
		var newProfileDate = newProfile.get_child(0).get_child(3)	
		var newProfileSelector = newProfile.get_child(1)
		newProfileSelector.set_meta("saveName", profile["userName"])
		newProfileName.text = profile["userName"]
		newProfileDay.text = str(profile["day"])
		newProfileMoney.text = str(profile["money"])
		newProfileDate.text = str(profile["date"])
		saveSlots.add_child(newProfile)
		newProfile.visible = true
		
func selectSave(save):
	currentSave = save
	
func deleteSave():
	var confirmationMessage = "You are about to delete the profile: " + currentSave
	var confirmed = await confirm(confirmationMessage)
	if confirmed == false:
		confirmationScreen.visible = false
		return
	var dict = preload("res://src/saves.json").data
	dict.erase(currentSave)
	var saveFile = FileAccess.open("res://src/saves.json",FileAccess.WRITE_READ)
	var newJson = JSON.stringify(dict)
	saveFile.store_string(newJson)
	saveFile.close()	
	drawSaveScreen()
	
func loadSave():
	var confirmationMessage = "You are about to load the profile: " + currentSave
	var confirmed = await confirm(confirmationMessage)
	if confirmed == false:
		confirmationScreen.visible = false
		return	
	var saves = preload("res://src/saves.json").data
	global.profile = saves[currentSave]
	emit_signal("loadGame")


func confirm(confirmMessage):
	confirmationScreen.visible = true
	$"Confirmation/BodyText".text = confirmMessage
	await buttonPressed
	if yesPressed == true:
		confirmationScreen.visible = false
		return true
	if noPressed == true: 
		confirmationScreen.visible = false
		return false
	noPressed = false
	yesPressed = false
	
func yesPress():
	yesPressed = true
	emit_signal("buttonPressed")
func noPress():
	noPressed = true
	emit_signal("buttonPressed")
