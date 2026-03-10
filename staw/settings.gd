extends Control
class_name config

static var volume = 0
static var difficulty = "easy"
signal configReady

func _ready():
	loadUserPreferences()
	emit_signal("configReady")
	
func loadUserPreferences():
	var	prefJson = preload("res://src/userPreferences.json")
	prefJson = prefJson.data
	volume = prefJson["Volume"]
	difficulty = prefJson["Difficulty"]

func saveUserPreferences():
	var	prefJson = preload("res://src/userPreferences.json")
	var dict = prefJson.data
	dict["Volume"] = volume
	dict["Difficulty"] = difficulty
	prefJson = FileAccess.open("res://src/userPreferences.json",FileAccess.WRITE_READ)
	var newJson = JSON.stringify(dict)
	prefJson.store_string(newJson)
	prefJson.close()
