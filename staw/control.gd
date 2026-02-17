extends Control
@export 
var currentIndustry = "Shipping"
@export
var Industries: Dictionary

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	print("HI")


func _on_start_game_pressed() -> void:
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	instantiateIndustries()
	makeStockScreen()

func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])

func makeStockScreen():
	var Industry = Industries[currentIndustry]
	var StockB = Industry["Stocks"][1]	
	var StockA = Industry["Stocks"][0]
	var minimum = findMinimum(StockA, StockB)
	var maximum = findMaximum(StockA, StockB)
	var maxHeight = $StockMenu/StockAGraph.size.y
	var scaleFactor = (maximum - minimum) / maxHeight
	print(minimum)
	print(maximum)
	print(scaleFactor)
	print((maximum - minimum)/scaleFactor)
	print(maxHeight)
	$StockMenu/StockAText/Title.text = StockA["stockShort"]
	$StockMenu/StockAText/TitleShort.text = StockA["companyName"]
	$StockMenu/StockBText/Title.text = StockB["stockShort"]
	$StockMenu/StockBText/TitleShort.text = StockB["companyName"]
		
	for x in range(StockA["timeFrame"].size()):
		var bar = get_node("StockMenu/StockAGraph/" + str(x+1))
		bar.set_size(Vector2(35, (StockA["timeFrame"][x] - minimum) / scaleFactor ) ) 
		if(StockA["timeFrame"][x-1] > StockA["timeFrame"][x]):
			bar.color = Color("darkred")	
		elif(StockA["timeFrame"][x-1] < StockA["timeFrame"][x]):
			bar.color = Color("darkgreen")	
		else:
			bar.color = get_node("StockMenu/StockAGraph/" + str(x)).color
		
	for x in range(StockB["timeFrame"].size()):
		#sizing
		
		var bar = get_node("StockMenu/StockBGraph/" + str(x+1))
		bar.set_size(Vector2(35, (StockB["timeFrame"][x] - minimum) / scaleFactor ) ) 
		
		#coloring
		if(StockB["timeFrame"][x-1] > StockB["timeFrame"][x]):
			bar.color = Color("darkred")	
		elif(StockB["timeFrame"][x-1] < StockB["timeFrame"][x]):
			bar.color = Color("darkgreen")	
		else:
			bar.color = get_node("StockMenu/StockBGraph/" + str(x)).color		
			
func findMinimum(stockA,stockB):
	var smallestB = stockB["timeFrame"][0]
	var smallestA = stockA["timeFrame"][0]
	for time in stockA["timeFrame"]:
		if time < smallestA:
			smallestA = time
	for time in stockB["timeFrame"]:
		if time < smallestB:
			smallestB = time
	return max(0, min( smallestA - 55, smallestB - 55 ))

func findMaximum(stockA,stockB):
	var largestB = stockB["timeFrame"][0]
	var largestA = stockA["timeFrame"][0]
	for time in stockA["timeFrame"]:
		if time > largestA:
			largestA = time
	for time in stockB["timeFrame"]:
		if time > largestB:
			largestB = time
	return max( largestA, largestB)
	
