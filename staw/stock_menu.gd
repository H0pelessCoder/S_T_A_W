extends Control

#connects to a function in IndustrySelector called 
#drawIndustrySelectors
signal drawStockSelectors 

##THIS IS THE STOCK MENU##

#relevant because both the stock and 
#trading menu scripts are nearly identical


# Draws the stock screen
func makeStockScreen():
	var Industry = global.Industries[global.currentIndustry]
	var StockB = Industry["Stocks"][1]	
	var StockA = Industry["Stocks"][0]
	
	#the range the stock screen is drawn at
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
	$StockDescriptionScreen.visible = false
	$RangeIndicators/Bottom.text = str(int(minimum))	
	$RangeIndicators/Top.text = str(int(maximum))
	$StockAText/PercentChange.text = str(snapped(pchangeA,0.01)) + "%"
	$StockBText/PercentChange.text = str(snapped(pchangeB,0.01)) + "%"
	
	##STOCK A##
	
	for x in range(StockA["timeFrame"].size()):
		
		var bar = get_node("StockAGraph/" + str(x+1))
		if bar == null:
			break
		#draws the stock bar to be at a height corresponding to its value
		bar.set_size(Vector2(35, (StockA["timeFrame"][x] - minimum) / scaleFactor ) ) 
		
		#if the previous stock bar is higher, be red, else be green
		if(StockA["timeFrame"][x-1] > StockA["timeFrame"][x]):
			bar.color = Color(1.157, 0.165, 0.242)
		else:
			bar.color = Color(0.0, 1.156, 0.379)

		
	##STOCK B##	
	
	for x in range(StockB["timeFrame"].size()):
		#sizing
		
		var bar = get_node("StockBGraph/" + str(x+1))
		if bar == null:
			break		
		#draws the stock bar to be at a height corresponding to its value
		bar.set_size(Vector2(35, (StockB["timeFrame"][x] - minimum) / scaleFactor ) ) 
		
		#if the previous stock bar is higher, be red, else be green
		if(StockB["timeFrame"][x-1] > StockB["timeFrame"][x]):
			bar.color = Color(1.157, 0.165, 0.242)	
		else:
			bar.color = Color(0.0, 1.156, 0.379)
			
			
	emit_signal("drawStockSelectors")
