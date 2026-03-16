extends Control

@onready
var LossContainer = "ProfitLossContainer/ScrollerLoss/LossContainer"
@onready
var ProfitContainer = "ProfitLossContainer/ScrollerProfit/ProfitContainer"

func _draw_profit_screen():
	var Market = global.Industries
	var profitTotal = 0
	var lossTotal = 0
	for industry in Market.keys():
		
		industry = Market[industry]
		for stock in industry["Stocks"]:
			
			if stock["savedStockPoint"] == 0:
				continue
			var stockProfit = calculateProfit(stock)
			
			if stockProfit <= 0:
				lossTotal += abs(stockProfit)
				var newColumn = get_node(LossContainer + "/LossText").duplicate()
				newColumn.add_theme_font_size_override("font_size", 16)
				get_node(LossContainer).add_child(newColumn)
				newColumn.text = stock["stockShort"] + "  -" + str(abs(stockProfit))
				
			if stockProfit > 0:
				profitTotal += abs(stockProfit)
				var newColumn = get_node(ProfitContainer + "/ProfitText").duplicate()
				newColumn.add_theme_font_size_override("font_size", 16)
				get_node(ProfitContainer).add_child(newColumn)
				newColumn.text = stock["stockShort"] + "  +" + str(abs(stockProfit))
				
	get_node(LossContainer + "/LossText").text = "LOSS -" + str(lossTotal)
	get_node(ProfitContainer + "/ProfitText").text = "PROFIT +" + str(profitTotal)
	$"TotalBox/TotalAmount".text = str(profitTotal - lossTotal)
	global.money += profitTotal - lossTotal
	$ReturnMenuButton.visible = false
	$SigningBox/Signature.text = global.profile["userName"]
	$SigningBox/Signature.visible_characters = 0
	
func calculateProfit(stock):
	var firstPoint = stock["firstStockPoint"]
	var buyIn = stock["savedStockPoint"]
	match stock["typeOfInvestment"]:
		"Long":
			return buyIn - firstPoint
		"Short":
			return firstPoint - buyIn
		_:
			return 0
