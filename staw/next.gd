extends Button

@onready
var textInput = $"../SigningBox/NameInputer"

func _on_name_inputer_text_changed():
	var userName = textInput.text
	visible = nameCheck(userName)
	
	
func nameCheck(userName):
	var saves = load("res://src/saves.json").data
	var correctLength = userName.length() <= 20
	var noSpecialCharacters = true
	for letter in userName.replace(" ",""):
		if !letter.is_valid_ascii_identifier() && !letter.is_valid_int():
			noSpecialCharacters = false
	var notAlreadyInUse = !userName in saves.keys()
	return (correctLength && noSpecialCharacters && notAlreadyInUse)
	
