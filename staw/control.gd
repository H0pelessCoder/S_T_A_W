extends Control
class_name global
signal determineNews
signal drawStockMenu
static var day := 0
static var currentIndustry := "Shipping"
static var Industries : Dictionary
static var News : Dictionary
static var availableEvents : Dictionary 

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	print("HI")


func _on_start_game_pressed() -> void:
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	instantiateIndustries()
	instantiateNews()
	emit_signal("drawStockMenu")
	emit_signal("determineNews")

func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])
		
func instantiateNews():
	var Njson = preload("res://src/news.json")
	News = Njson.data
	for event in News["Events"]:
		if News["Events"][event]["Prev"].size() == 0:
			availableEvents.set(event, News["Events"][event])

static func findMinimum(stockA,stockB):
	var smallestB = stockB["timeFrame"][0]
	var smallestA = stockA["timeFrame"][0]
	for time in stockA["timeFrame"]:
		if time < smallestA:
			smallestA = time
	for time in stockB["timeFrame"]:
		if time < smallestB:
			smallestB = time
	return max(0, min( smallestA - 55, smallestB - 55 ))

static func findMaximum(stockA,stockB):
	var largestB = stockB["timeFrame"][0]
	var largestA = stockA["timeFrame"][0]
	for time in stockA["timeFrame"]:
		if time > largestA:
			largestA = time
	for time in stockB["timeFrame"]:
		if time > largestB:
			largestB = time
	return max( largestA, largestB)
	
static func calculateStockChange(Stock):
	var change = Stock["timeFrame"][13] - Stock["timeFrame"][0]
	var pchange = change / Stock["timeFrame"][0]
	return pchange * 100
