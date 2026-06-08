extends Button
#connects to a function in MainMenu called 
#start_trading_section
signal startDay

#AHHHHHHHHHHHHHHHHHHHH

@onready
var TradingMenu = $"../../TradingMenu"

func _on_pressed() -> void:
	TradingMenu.visible = true
	get_node("..").visible = false
	emit_signal("startDay")
