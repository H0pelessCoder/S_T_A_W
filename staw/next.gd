extends Button
@onready
var textInput = $"../SigningBox/NameInputer"

func _on_name_inputer_text_changed():
	var userName = textInput.text
	visible = nameCheck(userName)
	
	
func nameCheck(userName):
	var saves = load("res://src/saves.json").data
	var correctLength = userName.length() <= 20 && userName.length() > 0
	var noSpecialCharacters = true
	print(userName)
	for letter in userName.replace(" ",""):
		if !letter.is_valid_ascii_identifier() && !letter.is_valid_int():
			noSpecialCharacters = false
	var notAlreadyInUse = !userName in saves.keys()
	return (correctLength && noSpecialCharacters && notAlreadyInUse)
	
func _input(event):
	if event.is_action_pressed("Submit"):
		while(textInput.text.ends_with(" ")):
			textInput.text = textInput.text.substr(0,textInput.text.length-2)
		textInput.text = textInput.text.replace(" ","")
		if(nameCheck(textInput.text)):
			emit_signal("pressed")
		
