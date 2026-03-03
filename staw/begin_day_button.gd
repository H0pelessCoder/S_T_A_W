extends Button
signal startDay
#AHHHHHHHHHHHHHHHHHHHH
@onready
var TradingMenu = $"../../TradingMenu"

func _on_pressed() -> void:
	TradingMenu.visible = true
	get_node("..").visible = false
