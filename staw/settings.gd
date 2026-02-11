extends Control


func _ready():
	print("HI")
#So lies here the bones of a failed save and load script,
#Know ye well oft forgotten traveller,
#These times lead to the downfall of men



#@export 
#var changedPreferences = {
#	
#}
#var UserPreferences = {
#	Volume = 100,
#	TRASH = 45
#}
#func _ready():
#	getUserPreferences()
#	print(UserPreferences)
#func getUserPreferences():
#	print("Hello!")
#	var file = FileAccess.open("res://src/User_Preferences.txt", FileAccess.READ).get_as_text()
#	print("Hi!")
#	var index = 0
#	while(index!=-1):
#		print(index)
#		var nextIndex = file.find(",",index)
#		print(nextIndex)
#		var bookmark = file.find(" ", index)
#		var variable = file.substr(index, bookmark)
#		bookmark = file.find(" ", bookmark + 1)
#		var number = file.substr(bookmark, nextIndex)
#		UserPreferences[variable] = number
#		index = nextIndex
