extends Control

signal drawStockSelectors 

# Called when the node enters the scene tree for the first time.
func makeStockScreen():
	var Industry = global.Industries[global.currentIndustry]
	var StockB = Industry["Stocks"][1]	
	var StockA = Industry["Stocks"][0]
	var minimum = global.findMinimum(StockA, StockB)
	var maximum = global.findMaximum(StockA, StockB)
	var maxHeight = $StockAGraph.size.y
	var scaleFactor = (maximum - minimum) / maxHeight
	var pchangeA = global.calculateStockChange(StockA)
	
	var pchangeB = global.calculateStockChange(StockB)
	$StockAText/Title.text = StockA["stockShort"]
	$StockAText/TitleShort.text = StockA["companyName"]
	$StockBText/Title.text = StockB["stockShort"]
	$StockBText/TitleShort.text = StockB["companyName"]
	$RangeIndicators/Bottom.text = str(int(minimum))	
	$RangeIndicators/Top.text = str(int(maximum))
	$StockAText/PercentChange.text = str(snapped(pchangeA,0.01)) + "%"
	$StockBText/PercentChange.text = str(snapped(pchangeB,0.01)) + "%"
	for x in range(StockA["timeFrame"].size()):
		
		var bar = get_node("StockAGraph/" + str(x+1))
		bar.set_size(Vector2(35, (StockA["timeFrame"][x] - minimum) / scaleFactor ) ) 
		if(StockA["timeFrame"][x-1] > StockA["timeFrame"][x]):
			bar.color = Color("darkred")	
		elif(StockA["timeFrame"][x-1] < StockA["timeFrame"][x]):
			bar.color = Color("darkgreen")	
		else:
			bar.color = get_node("StockAGraph/" + str(x)).color
		
		
	for x in range(StockB["timeFrame"].size()):
		#sizing
		
		var bar = get_node("StockBGraph/" + str(x+1))
		bar.set_size(Vector2(35, (StockB["timeFrame"][x] - minimum) / scaleFactor ) ) 
		
		#coloring
		if(StockB["timeFrame"][x-1] > StockB["timeFrame"][x]):
			bar.color = Color("darkred")	
		elif(StockB["timeFrame"][x-1] < StockB["timeFrame"][x]):
			bar.color = Color("darkgreen")	
		else:
			bar.color = get_node("StockBGraph/" + str(x)).color		
		emit_signal("drawStockSelectors")
