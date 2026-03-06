extends Control
class_name global
signal determineNews
signal drawStockMenu
signal drawTradingMenu
static var day := -1
static var currentIndustry := "Shipping"
static var Industries : Dictionary
static var News : Dictionary
static var availableEvents : Dictionary 
static var currTime := -1

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	pass

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
	availableEvents = eventController.sortEvents(availableEvents)
	
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
	
## Controlling the Trading Menu ##

	## ONCE THE TRADING SECTION IS OVER ##
func _on_timer_timeout() -> void:
	
	 # Replace with function body.
	print("TIMEOUT!!!!!")
	#self.visible = true
	$NewsMenu.visible = true
	$TradingMenu.visible = false
	emit_signal("determineNews")
	emit_signal("drawStockMenu")
	
	#This will lead to profit screen and stuff
	## INITS THE TRADING SECTION ##		
func _on_start_day() -> void:
	print("NewDay")
	#TODO: USE NEWS EVENTS
	for industry in Industries.keys():
		industry = Industries[industry]
		#Stock A
		var Stock = industry["Stocks"][0]
		Stock["savedStockPoint"] = -1
		var variance = 4
		var maxVariance = 30
		var first = Stock["timeFrame"][13]
		var last = findVelocity(Stock) + first
		var newTimeframe = generateStockTimeframe(first, last, variance, 14, maxVariance)
		Stock["newTimeFrame"] = newTimeframe
		Stock["firstStockPoint"] = first
		#Stock B
		Stock = industry["Stocks"][1]
		Stock["savedStockPoint"] = -1
		variance = 4
		maxVariance = 30
		first = Stock["timeFrame"][13]
		last = findVelocity(Stock) + first
		newTimeframe = generateStockTimeframe(first, last, variance, 14, maxVariance)
		Stock["newTimeFrame"] = newTimeframe
		Stock["firstStockPoint"] = first
	$TradingMenu/Timer.start()
	$TradingMenu/subTimer.start()
	emit_signal("drawTradingMenu")
		
			
#TODO USE NEWS EVENTS
func findVelocity(stock):
	return randi_range(-50,50)

func generateStockTimeframe(first, last, variance, amount, maxVariance):
	var timeframe = [first]
	var increments = (last - first) / (amount-2)
	for x in range(amount-2):
		var variant = randf_range(-variance, variance)
		var change = increments * variant
		var next = (timeframe[x-1] + change)
		var whereItShouldBe = (increments * x) + first
		if next > whereItShouldBe + maxVariance or next < whereItShouldBe - maxVariance:
			next = whereItShouldBe
		timeframe.append(int(next))
	timeframe.append(last)
	return timeframe
	 
