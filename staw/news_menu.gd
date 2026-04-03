extends Control
class_name eventController

static func eventFormat() -> Dictionary:
	return {
	"Super" : [],
	"Major" : [],
	"Minor" : []
	}
static var happeningEvents := eventFormat()
static var pendingEvents := eventFormat()
static var availableEvents : Dictionary 
func determineTodaysNews():
	happeningEvents = eventFormat()
	global.day += 1
	var Events = global.News["Events"]
	var eventsToProcess = availableEvents
	chooseEvents(pendingEvents)
	chooseEvents(eventsToProcess)
	global.save()
	loadNewsScreen()
	for type in happeningEvents.keys():
		for event in happeningEvents.get(type):
			event = getEvent(event)
			event["Done"] = true
			randomize()
			for next in event["Next"]:
				next = getEvent(next)
				pendingEvents[next["Type"]].append(next["Title"])
	happeningEvents = eventFormat()
#Takes list of strings
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
static func sortEvents(Events):
	var sortedEvents = eventFormat()
	for event in Events.keys():
		sortedEvents.get(Events.get(event)["Type"]).append(event)
	return sortedEvents

#Takes String
func isEventAllowed(event):
	event = getEvent(event)
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
	
static func getEvent(event):
	return global.News["Events"][event]

func loadNewsScreen():
	for child in $EventList/Horiz.get_children():
		if child.visible == true:
			child.free()
	var Events = global.News["Events"]
	for type in happeningEvents.keys():

		for event in happeningEvents[type]:
			var eventNode = $"EventList/Horiz/EventBase".duplicate()
			$"EventList/Horiz".add_child(eventNode)
			eventNode.visible = true
			var header = get_node(str(eventNode.get_path()) + "/EventHeader")
			header.text = Events[event]["NewsTitle"]
			
			var body = get_node(str(eventNode.get_path()) + "/EventBody")
			body.text = Events[event]["NewsFull"]
			if type == "Super":
				pass
				#I dont have any images yet

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

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
