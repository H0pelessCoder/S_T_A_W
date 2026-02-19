extends Button
signal drawStockMenu
@onready
var StockScreen = $"../../StockMenu"

func _on_pressed() -> void:
	get_node("..").visible = false
	StockScreen.visible = true
	emit_signal("drawStockMenu")
