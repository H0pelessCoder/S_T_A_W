extends Button



func _on_pressed() -> void:
	var industry = global.currentIndustry
	industry = global.Industries[industry]
	var stock = industry["Stocks"][get_meta("Stock")]
	if stock["savedStockPoint"] != -1:
		return
	stock["savedStockPoint"] = stock["timeFrame"][13]
	stock["typeOfInvestment"] = get_meta("typeOfInvestment")
	print(["typeOfInvestment"])	
