extends Control
@export 
var currentIndustry = "Shipping"
@export
var Industries: Dictionary

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	print("HI")


func _on_start_game_pressed() -> void:
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	instantiateIndustries()
	makeStockScreen()

func instantiateIndustries():
	var Ijson = preload("res://src/stocks.json")
	for Industry in Ijson.data:
		Industries.set(Industry, Ijson.data[Industry])

func makeStockScreen():
	var Industry = Industries[currentIndustry]
	
	var StockA = Industry["Stocks"][0]
	$StockMenu/StockAText/Title.text = StockA["stockShort"]
	$StockMenu/StockAText/TitleShort.text = StockA["companyName"]
	for x in range(StockA["timeFrame"].size()):
		var txt = "StockMenu/StockAGraph/" + str(x+1)
		get_node(txt).set_size(Vector2(35, StockA["timeFrame"][x]/2))
		

	var StockB = Industry["Stocks"][1]
	$StockMenu/StockBText/Title.text = StockB["stockShort"]
	$StockMenu/StockBText/TitleShort.text = StockB["companyName"]
	for x in range(StockB["timeFrame"].size()):
		var txt = "StockMenu/StockBGraph/" + str(x+1)
		get_node(txt).set_size(Vector2(35, StockB["timeFrame"][x]/2))
