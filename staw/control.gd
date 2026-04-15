extends Control
class_name global
signal determineNews
signal drawStockMenu
signal drawTradingMenu
signal drawSaveScreen
signal drawNewsScreen
signal drawProfitScreen
static var money = 0
static var day := -1
static var currentIndustry := "Shipping"
static var Industries : Dictionary
static var gameStarted = false
static var profile : Dictionary
static var News : Dictionary
static var currTime := -1

func _on_button_pressed():
	if is_instance_valid(global.profile):
		print("valid")
		save()
	get_tree().quit() # Replace with function body.

#func _ready():
#	instantiateIndustries()
#	instantiateNews()

	
static func save():
	
	global.profile["day"] = global.day
	global.profile["money"] = global.money
	global.profile["stocks"] = global.Industries
	global.profile["events"] = global.News
	global.profile["availableEvents"] = eventController.availableEvents
	global.profile["pendingEvents"] = eventController.pendingEvents
	global.profile["happeningEvents"] = eventController.happeningEvents
	global.profile["currEffects"] = eventController.currEffects
	var dict = preload("res://src/saves.json").data
	dict.set(global.profile["userName"], global.profile)
	var saveFile = FileAccess.open("res://src/saves.json",FileAccess.WRITE_READ)
	var newJson = JSON.stringify(dict)
	saveFile.store_string(newJson)
	saveFile.close()	

	
func newGame():
	loadGame()
	emit_signal("determineNews")	
	startGame()
		
func loadGame():
	global.day = global.profile["day"]
	global.money = global.profile["money"]
	global.Industries = global.profile["stocks"]
	global.News = global.profile["events"]
	eventController.availableEvents = global.profile["availableEvents"]
	eventController.pendingEvents = global.profile["pendingEvents"]
	eventController.happeningEvents = global.profile["happeningEvents"]
	eventController.currEffects = global.profile["currEffects"]
	emit_signal("drawNewsScreen")
	startGame()
	
func startGame():
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	emit_signal("drawStockMenu")
				
func _on_load_game_pressed() -> void:

	$MainMenu.visible = false
	$SaveScreen.visible = true
	emit_signal("drawSaveScreen")
	
static func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])

static func instantiateNews():
	var Njson = preload("res://src/news.json")
	News = {}
	eventController.availableEvents = {}
	#Deep duplicates json datab
	News = JSON.parse_string(JSON.stringify(Njson.data))
	for event in News["Events"]:
		if News["Events"][event]["Prev"].size() == 0:
			eventController.availableEvents.set(event, News["Events"][event])
	eventController.availableEvents = eventController.sortEvents(eventController.availableEvents)
	
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
	emit_signal("drawStockMenu")
	emit_signal("drawProfitScreen")
	$ProfitScreen.visible = true
	$TradingMenu.visible = false
	emit_signal("determineNews")	
	
	#This will lead to profit screen and stuff
	## INITS THE TRADING SECTION ##		
func _on_start_day() -> void:
	print("NewDay")
	#TODO: USE NEWS EVENTS
	global.currTime = 0
	var sectionLength = 60 / config.difficulty 
	$TradingMenu/Timer.wait_time = sectionLength
	$TradingMenu/subTimer.wait_time = sectionLength / 15
	for industry in Industries.keys():
		industry = Industries[industry]
		for Stock in industry["Stocks"]:
			var first = Stock["timeFrame"][13]
			Stock["firstStockPoint"] = first
			Stock["savedStockPoint"] = 0
			var variance = Stock["firstStockPoint"]/100
			var maxVariance = findVariance(Stock)
			var last = findVelocity(Stock) + first
			var newTimeframe = generateStockTimeframe(first, last, variance, 14, maxVariance)
			Stock["newTimeFrame"] = newTimeframe
	$TradingMenu/Timer.start()
	$TradingMenu/subTimer.start()
	emit_signal("drawTradingMenu")
		
			
#TODO USE NEWS EVENTS
func findVelocity(stock):
	var minSwing = stock["firstStockPoint"]/20	
	var velocity = randi_range(minSwing, minSwing * -1)
	var stockName = stock["companyName"]
	var effects = eventController.currEffects[stockName]
	return velocity + effects["Velocity"]
	
func findVariance(stock):
	var variance = 30
	var stockName = stock["companyName"]
	var effects = eventController.currEffects[stockName]
	return variance + effects["Variance"]
	
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
	 
