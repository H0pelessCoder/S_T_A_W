extends Control
class_name config

static var volume = 0
static var difficulty = 1
static var difficultyName = "Easy"
signal configReady

func _ready():
	loadUserPreferences()
	emit_signal("configReady")
		
func loadUserPreferences():
	var	prefJson = preload("res://src/userPreferences.json")
	prefJson = prefJson.data
	volume = prefJson["Volume"]
	difficulty = prefJson["Difficulty"]
	difficultyName = prefJson["DifficultyName"]
	setDifficulty(difficulty, difficultyName)
	
func saveUserPreferences():
	var	prefJson = preload("res://src/userPreferences.json")
	var dict = prefJson.data
	dict["Volume"] = volume
	dict["Difficulty"] = difficulty
	dict["DifficultyName"] = difficultyName
	prefJson = FileAccess.open("res://src/userPreferences.json",FileAccess.WRITE_READ)
	var newJson = JSON.stringify(dict)
	prefJson.store_string(newJson)
	prefJson.close()
	
#most of this is just to make it visually look like you have
#the difficulty selected
func setDifficulty(newDifficulty, buttonName):
	var setter = get_node("DifficultySetter/" + difficultyName + "Setter")
	var indicator = setter.get_child(1)
	indicator.visible = false
	difficultyName = buttonName
	setter = get_node("DifficultySetter/" + buttonName + "Setter")
	indicator = setter.get_child(1)
	indicator.visible = true
	difficulty = newDifficulty
