extends Control

var pendingEvents : Dictionary

func determineTodaysNews():
	print("Something Happened")
	var nEvents = global.News["dailyEvents"][str(global.day)]
	var Events = global.News["Events"]

func sortEvents(Events):
	var sortedEvents = {
		"Super" : [],
		"Major" : [],
		"Minor" : []
	}
	for event in Events.keys():
		sortedEvents.get(Events.get(event)["Type"]).append(event)
	return sortedEvents
