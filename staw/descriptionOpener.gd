extends Button

@onready 
var descriptionScreen = "../../StockDescriptionScreen"

#gets the stock description from the global var industries
func _on_pressed():
	var Stock = global.Industries[global.currentIndustry]["Stocks"][get_meta("Stock")]
	get_node(descriptionScreen + "/StockTitle").text =  Stock["companyName"]
	get_node(descriptionScreen + "/Scroller/StockDescription").text = Stock["stockDescription"]
	get_node(descriptionScreen).visible = true
	
	
