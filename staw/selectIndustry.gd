extends Button

signal drawStockMenu


func _on_pressed():
	var newIndustry = (int(self.name) - 1) + IndustryTabs.currentIndustryPosition
	global.currentIndustry = global.Industries.keys()[newIndustry]
	emit_signal("drawStockMenu")
