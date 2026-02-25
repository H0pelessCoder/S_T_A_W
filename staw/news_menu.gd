extends Control
func eventFormat() -> Dictionary:
	return {
	"Super" : [],
	"Major" : [],
	"Minor" : []
	}
var happeningEvents := eventFormat()
var pendingEvents := eventFormat()

func testNextDay():
	pendingEvents = eventFormat()
	global.day += 1
	var Events = global.News["Events"]
	for type in happeningEvents:
		for event in happeningEvents.get(type):
			event = global.News["Events"][event]
			event["done"] = true
			randomize()
			if event["Next"].size() !=0 :
				var randomInt = randi() % 100
				var nextEvent = -1
				var progress = 0 # this is an awful variable name :(
				while randomInt > progress:
					nextEvent += 1
					var probability = event["Next"][Events.keys()[nextEvent]]
					progress = progress + (probability * 100)
				nextEvent = Events[nextEvent]
				pendingEvents.get(nextEvent["Type"]).append(nextEvent["Title"])
	happeningEvents = eventFormat()
	print(pendingEvents)
	if global.day == 1:
		determineTodaysNews()
	
func determineTodaysNews():
	var Events = global.News["Events"]
	var eventsToProcess = sortEvents(global.availableEvents)
	chooseEvents(pendingEvents)
	chooseEvents(eventsToProcess)
	print(happeningEvents)
	print(pendingEvents)
	testNextDay()
			#pick a random event from the dict
			
func chooseEvents(Events):
	var nEvents = global.News["dailyEvents"][str(global.day)]
	for type in nEvents.keys():
		for N in range(nEvents[type]):
			randomize()
			if Events[type].size() == 0: continue
			var typeSize = Events[type].size()
			var randomIndex = randi_range(0, typeSize-1)
			var event = Events[type][randomIndex]
			happeningEvents.get(type).append(event)
			Events.get(type).pop_at(randomIndex)
			
func sortEvents(Events):
	var sortedEvents = eventFormat()
	for event in Events.keys():
		sortedEvents.get(Events.get(event)["Type"]).append(event)
	return sortedEvents
