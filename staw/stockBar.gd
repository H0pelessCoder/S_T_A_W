extends ColorRect

@onready 
var StockIndicator = $"../StockIndicator"
# Called when the node enters the scene tree for the first time.


func _on_mouse_entered():
	var stockNumber = get_node("..").get_meta("stock")
	var stock = global.Industries[global.currentIndustry]["Stocks"][stockNumber]
	var marketCap = stock["timeFrame"][int(self.name)-1]
	var newPositionX = self.position.x - self.size.x
	var newPositionY = self.position.y - self.size.y - 30
	StockIndicator.set_position(Vector2(newPositionX, newPositionY))
	StockIndicator.text = str(int(marketCap))
	StockIndicator.visible = true


func _on_mouse_exited():
	StockIndicator.visible = false
