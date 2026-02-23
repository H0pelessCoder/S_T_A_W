extends Control
class_name global

signal drawStockMenu
static var currentIndustry := "Shipping"
static var Industries : Dictionary

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	print("HI")


func _on_start_game_pressed() -> void:
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	instantiateIndustries()
	emit_signal("drawStockMenu")

func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])


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
	print(change)
	var pchange = change / Stock["timeFrame"][0]
	print(pchange)
	return pchange
