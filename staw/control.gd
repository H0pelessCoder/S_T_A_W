extends Control
class_name global

#connects to a function in NewsMenu called 
#determineTodaysNews
signal determineNews


#connects to a function in StockMenu called 
#makeStockScreen
signal drawStockMenu

#connects to a function in TradingMenu called 
#makeStockScreen
signal drawTradingMenu

#connects to a function in TradingMenu called 
#reset_Chi_Wave
signal resetChi

#connects to a function in SaveScreen called 
#determineTodaysNews
signal drawSaveScreen

#connects to a function in NewsMenu called 
#loadNewsScreen
signal drawNewsScreen

#connects to a function in ProfitScreen called 
#_draw_profit_screen
signal drawProfitScreen


#can be negative or positive
static var money = 0

#incremented after the trading section 
#ends in the function _on_timer_timeout
static var day := 0

#Day at which demo ends
static var maxDay := 2

#Selected industry; used to draw stock screen and determine which stock
#is bought when user takes a long or short position
static var currentIndustry := "Shipping"

#Dictionary containing the hiearchy
#Industries > Stocks > StockTimeLine
static var Industries : Dictionary

#var containing a gamestate
#contains the following vars:
#day, money, quota, stocks, events, 
#availableEvents, pendingEvents, 
#happeningEvents, currEffects
static var profile : Dictionary

#maps event names to event definitions
#contains all events
static var News : Dictionary

#the current index of the stock timeframe
#used by the trading menu to determine at which
#price stocks are bought and to shift the stock bars
#as the trading section progresses
static var currTime := -1

#unnused; in theory it would increment as the game
#progressed providing a scaling challenge
static var quota = 0


#if the user is currently in a game, save before quitting
func _on_button_pressed():
	if is_instance_valid(global.profile):
		print("valid")
		save()
	get_tree().quit() # Replace with function body.

#func _ready():
#	instantiateIndustries()
#	instantiateNews()

#updates the profile with all the global variables
#then puts them in the save json under the profile name	
static func save():
	
	global.profile["day"] = global.day
	global.profile["money"] = global.money
	global.profile["quota"] = global.quota
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

#When a new game is created
#determine the day's news	
func newGame():
	loadGame()
	emit_signal("determineNews")	
	startGame()
	
#sets all global variables to the save's variables	
func loadGame():
	global.day = global.profile["day"]
	global.money = global.profile["money"]
	global.Industries = global.profile["stocks"]
	global.News = global.profile["events"]
	global.quota = global.profile["quota"]
	eventController.availableEvents = global.profile["availableEvents"]
	eventController.pendingEvents = global.profile["pendingEvents"]
	eventController.happeningEvents = global.profile["happeningEvents"]
	eventController.currEffects = global.profile["currEffects"]
	emit_signal("drawNewsScreen")
	startGame()

#when a game is started
#make the main menu invisible
#news menu visible
#and prepare the stock screen
func startGame():
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	emit_signal("drawStockMenu")

#opens the save menu			
func _on_load_game_pressed() -> void:

	$MainMenu.visible = false
	$SaveScreen.visible = true
	emit_signal("drawSaveScreen")

#loads the industries json and populates the game data with it
static func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])

#populates appropiate global variables with the base news json
static func instantiateNews():
	var Njson = preload("res://src/news.json")
	global.News = {}
	eventController.availableEvents = {}
	#Deep duplicates json database
	global.News = JSON.parse_string(JSON.stringify(Njson.data))
	#populates availableEvents by checking which events do not have any prerequisites 
	#and are available from day one
	for event in global.News["Events"]:
		if global.News["Events"][event]["Prev"].size() == 0:
			eventController.availableEvents.set(event, global.News["Events"][event])
	eventController.availableEvents = eventController.sortEvents(eventController.availableEvents)
	
#finds the point at which either of two stocks were at their lowest
#value; used to draw the stock screen;
static func findMinimum(stockA,stockB):
	var smallestB = stockB["timeFrame"][0]
	var smallestA = stockA["timeFrame"][0]
	for time in stockA["timeFrame"]:
		if time < smallestA:
			smallestA = time
	for time in stockB["timeFrame"]:
		if time < smallestB:
			smallestB = time
	#the magic number of 55 is to make the stock screen more visually appealing
	#by making it so that even at the lowest stock point the bar is still visible
	return max(0, min( smallestA - 55, smallestB - 55 ))
	
#finds the point at which either of two stocks were at their maximum
#value; used to draw the stock screen
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

#returns a percent change in a stock
static func calculateStockChange(Stock):
	var change = float(Stock["timeFrame"][13] - Stock["timeFrame"][0])
	#if change isn't a float, then the math is done as an int dividing by an
	#int, which rounds to 0. This isn't a problem in the first day,
	#because all the values there were generated by hand by me,
	#which means they are automatically floats
	#but on the second day, any value that is not the first or last
	#(Which are also generated as floats)
	#are generated as ints
	#Which makes it so all percentages in the entire game round to 0
	# i hate godot
	var pchange = change / Stock["timeFrame"][0]
	return pchange * 100
	
## ONCE THE TRADING SECTION IS OVER ##
func _on_timer_timeout() -> void:
		
	 # Replace with function body.
	print("TIMEOUT!!!!!")
	#self.visible = true
	emit_signal("drawStockMenu")
	emit_signal("drawProfitScreen")
	$ProfitScreen.visible = true
	$TradingMenu.visible = false
	global.day += 1
	if(day >= maxDay):
		return		
	emit_signal("determineNews")	
	emit_signal("resetChi")
	
## INITS THE TRADING SECTION ##		
func _on_start_day() -> void:
	print("NewDay")
	#TODO: USE NEWS EVENTS
	global.currTime = 0
	var sectionLength = 60 / config.difficulty 
	$TradingMenu/Timer.wait_time = sectionLength
	$TradingMenu/subTimer.wait_time = sectionLength / 15
	#Generates the next stock timeframe for each stock
	for industry in Industries.keys():
		industry = Industries[industry]
		for Stock in industry["Stocks"]:
			#acquires the variables used by the
			#timeframe generation function
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
		
#returns where the stock's value will end up 
#after the trading section
func findVelocity(stock):
	#the normal amount a stock can swing by is 5%
	var minSwing = stock["firstStockPoint"]/20	
	#randomizes what the actual value is
	var velocity = randi_range(minSwing, minSwing * -1)
	var stockName = stock["companyName"]
	var effects = eventController.currEffects[stockName]
	return velocity * effects["Velocity"]

#the variance only affects how much the stock will oscillate 
#during the trading section, DOES NOT AFFECT VELOCITY!
func findVariance(stock):
	#magic number, 30 usually ends up working
	var variance = 30
	var stockName = stock["companyName"]
	var effects = eventController.currEffects[stockName]
	return variance * effects["Variance"]

#generates a timeframe for a stock
#the last and first positions for a stock are given
#this function only generates the inbetween
func generateStockTimeframe(first, last, variance, amount, maxVariance):
	var timeframe = [first]
	#if a stock goes from 100 to 200 in ten steps
	#increments = 10
	#increments gets multuplied by a random value 
	#to simulate the wild oscillations of the stock market
	var increments = (last - first) / (amount-2)
	for x in range(amount-2):
		var variant = randf_range(-variance, variance)
		var change = increments * variant
		var next = (timeframe[x-1] + change)
		#if the stock deviates from where it should be by more
		#then max variance, resets it
		var whereItShouldBe = (increments * x) + first
		if next > whereItShouldBe + maxVariance or next < whereItShouldBe - maxVariance:
			next = whereItShouldBe
		timeframe.append(int(next))
	timeframe.append(last)
	return timeframe
	 
