extends Control

@onready
var LossContainer = "ProfitLossContainer/ScrollerLoss/LossContainer"
@onready
var ProfitContainer = "ProfitLossContainer/ScrollerProfit/ProfitContainer"

#draws the profit screen
func _draw_profit_screen():
	for child in $ProfitLossContainer/ScrollerProfit/ProfitContainer.get_children():
		if !child.name == "ProfitText":
			child.free()
	for child in $ProfitLossContainer/ScrollerLoss/LossContainer.get_children():
		if !child.name == "LossText":
			child.free()
	var Market = global.Industries
	var profitTotal = 0
	var lossTotal = 0
	#gets every industry that was bought and adds their totals together
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
				newColumn.text = stock["stockShort"] + "  -" + str(abs(snapped(stockProfit,2)))
				
			if stockProfit > 0:
				profitTotal += abs(stockProfit)
				var newColumn = get_node(ProfitContainer + "/ProfitText").duplicate()
				newColumn.add_theme_font_size_override("font_size", 16)
				get_node(ProfitContainer).add_child(newColumn)
				newColumn.text = stock["stockShort"] + "  +" + str(abs(snapped(stockProfit,2)))
				
	get_node(LossContainer + "/LossText").text = "LOSS -" + str(snapped(lossTotal,2))
	get_node(ProfitContainer + "/ProfitText").text = "PROFIT +" + str(snapped(profitTotal,2))
	$"TotalBox/TotalAmount".text = str(snapped((profitTotal - lossTotal),2))
	global.money += profitTotal - lossTotal
	$ReturnNewsButton.visible = false
	$SigningBox/Signature.text = global.profile["userName"]
	$SigningBox/Signature.visible_characters = 0
	
func calculateProfit(stock):
	var firstPoint = stock["timeFrame"][13]
	var buyIn = stock["savedStockPoint"]
	match stock["typeOfInvestment"]:
		"Long":
			return buyIn - firstPoint
		"Short":
			return firstPoint - buyIn
		_:
			return 0
