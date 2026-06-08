extends Control
class_name eventController

static func eventFormat() -> Dictionary:
	return {
	"Super" : [],
	"Major" : [],
	"Minor" : []
	}
static func effectFormat() -> Dictionary:
	return {
		"Velocity" : 1,
		"Variance" : 1
	}

#these are the events that are confirmed to be happening
static var happeningEvents := eventFormat()

#these events are first in the queue to happen in a day
#events that are given priority are ones that follow in 
#an event chain that has already started
static var pendingEvents := eventFormat()

#this is a list of all events that are valid to happen
static var availableEvents : Dictionary 

#stores effects for each stock, industry, and market
static var currEffects : Dictionary

#populates happening events and event effects
func determineTodaysNews():
	happeningEvents = eventFormat()
	currEffects = {}
	var Events = global.News["Events"]
	if(global.profile["userName"] == "Admin"):
		happeningEvents = availableEvents
	var eventsToProcess = availableEvents
	print(eventsToProcess)
	#populates from pending events first
	chooseEvents(pendingEvents)
	chooseEvents(eventsToProcess)	
	processEffects()
	global.save()
	loadNewsScreen()
	#sets all events that are happening to be marked as completed
	#then adds the next events in the event chain to the pending queue
	for type in happeningEvents.keys():
		for event in happeningEvents.get(type):
			event = getEvent(event)
			event["Done"] = true
			for next in event["Next"]:
				next = getEvent(next)
				pendingEvents[next["Type"]].append(next["Title"])
	happeningEvents = eventFormat()

#proccesses every events effects
#in the format of stock: {variance, velocity}, ...
func processEffects():
	var Events = global.News["Events"]
	var Industries = global.Industries
	for industry in Industries:
		for stock in Industries[industry]["Stocks"]:
			currEffects.set(stock["companyName"], effectFormat())
	for eventType in happeningEvents:
		for event in happeningEvents[eventType]:
			event = Events[event]["Effects"]
			var marketVelocity = event["Market"]["Velocity"] -1
			var marketVariance = event["Market"]["Variance"] -1
			var IndustryVelocity = 0
			var IndustryVariance = 0
			for industry in event["Industries"]:
				IndustryVelocity += event["Industries"][industry]["Effects"]["Velocity"] -1
				IndustryVariance += event["Industries"][industry]["Effects"]["Variance"] -1
				var x = 0
				for stockEffect in event["Industries"][industry]["Stocks"]:
					var stockVelocity = stockEffect["Velocity"] -1
					var stockVariance = stockEffect["Variance"] -1
					var stock = Industries[industry]["Stocks"][x]
					var stockName = stock["companyName"]
					currEffects[stockName]["Velocity"] += marketVelocity + IndustryVelocity + stockVelocity 
					currEffects[stockName]["Variance"] += marketVariance + IndustryVariance + stockVariance			
					x=1			

#for every event allowed in a day, gets a random event
func chooseEvents(Events):
	var nEvents = global.News["dailyEvents"][str(global.day)]
	for type in nEvents.keys():
		for N in range(nEvents[type]):
			randomize()
			if Events[type].size() == 0: continue
			var typeSize = Events[type].size()
			var randomIndex = randi_range(0, typeSize-1)
			var event = Events[type][randomIndex]
			if isEventAllowed(event):
				happeningEvents.get(type).append(event)
				Events.get(type).pop_at(randomIndex)
			else:
				if !pendingEvents.has(event):
					pendingEvents[type].append(event)
				N-=1
				
#Called from Instantiate News, Events must be unsorted
#Converts a list of events to the event format
static func sortEvents(Events):
	var sortedEvents = eventFormat()
	for event in Events.keys():
		sortedEvents.get(Events.get(event)["Type"]).append(event)
	return sortedEvents

#returns whether or not an event is valid to be chosen
func isEventAllowed(event):
	event = getEvent(event)
	if event["Day"] > global.day:
		return false
	for exclusive in event["Mutually_Exclusive"]:
		exclusive = getEvent(exclusive)
		if exclusive["Done"] == true:
			return false
	for preq in event["Prev"]:
		preq = getEvent(preq)
		if preq["Done"] == false:
			return false
	if event["Done"] == true:
		return false
	return true	

#converts an event name into an event dictionary
static func getEvent(event):
	return global.News["Events"][event]

#draws the stock screen
func loadNewsScreen():
	#clears all current events
	for child in $EventList/Horiz.get_children():
		if child.visible == true:
			child.free()
	var Events = global.News["Events"]
	#adds new events
	for type in happeningEvents.keys():
		
		for event in happeningEvents[type]:
			var eventNode = $"EventList/Horiz/EventBase".duplicate()
			$"EventList/Horiz".add_child(eventNode)
			eventNode.visible = true
			var header = get_node(str(eventNode.get_path()) + "/EventHeader")
			header.text = Events[event]["NewsTitle"]
			
			var body = get_node(str(eventNode.get_path()) + "/EventBody")
			body.text = Events[event]["NewsFull"]
			#Super events theoritcally would also get an image...
			if type == "Super":
				pass
				#...But i haven't implemented that yet

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

#ill have to add this in as a stretch. Too much work for now.
func randomNextEvent():
	pass
	#var randomInt = randi() % 100
	#var nextEvent = -1
	#var progress = 0 # this is an awful variable name :(
	#while randomInt > progress:
	#	nextEvent += 1
	#	var probability = event["Next"][event["Next"].keys()[nextEvent]]
	#	progress = progress + (probability * 100)
