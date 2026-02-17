extends Button

@onready 
var descriptionScreen = "../../../StockDescriptionScreen"


func _on_pressed():
	print("Pressed")
	var Stock = global.Industries[global.currentIndustry]["Stocks"][get_meta("Stock")]
	get_node(descriptionScreen + "/StockTitle").text =  Stock["companyName"]
	get_node(descriptionScreen + "/StockDescription").text = Stock["stockDescription"]
	get_node(descriptionScreen).visible = true
	
	
