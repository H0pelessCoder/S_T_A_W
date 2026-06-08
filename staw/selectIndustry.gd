extends Button

signal drawStockMenu

#shifts the available industries option by one
func _on_pressed():
	var newIndustry = (int(self.name) - 1) + IndustryTabs.currentIndustryPosition
	global.currentIndustry = global.Industries.keys()[newIndustry]
	emit_signal("drawStockMenu")
	
