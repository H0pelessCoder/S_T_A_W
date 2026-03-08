extends Control
signal drawStockSelectors 

#THIS IS THE TRADING MENU



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
		
		
	for x in range(StockB["timeFrame"].size()):
		#sizing
		var bar = get_node("StockBGraph/" + str(x+1))
		bar.set_size(Vector2(35, (StockB["timeFrame"][x] - minimum) / scaleFactor ) ) 
		
		#coloring
		if(StockB["timeFrame"][x-1] > StockB["timeFrame"][x]):
			bar.color = Color("darkred")	
		elif(StockB["timeFrame"][x-1] < StockB["timeFrame"][x]):
			bar.color = Color("darkgreen")	
		
		print(StockA["savedStockPoint"])
		if(StockA["savedStockPoint"] != 0 || StockB["savedStockPoint"] != 0):
			$StockAText/Blocker.visible = true
			$StockBText/Blocker.visible = true
		else:
			$StockAText/Blocker.visible = false
			$StockBText/Blocker.visible = false
			
		emit_signal("drawStockSelectors")


func _on_sub_timer_timeout() -> void:
	print("SubTImerout!!!!")
	global.currTime += 1
	if global.currTime > 13:
		$subTimer.stop()
		return
	for industry in global.Industries.keys():
		industry = global.Industries[industry]
		var Stock = industry["Stocks"][0]
		var x = 0
		for time in Stock["timeFrame"]:
			if x == 13:
				Stock["timeFrame"][x] = Stock["newTimeFrame"][global.currTime]
			else:
				Stock["timeFrame"][x] = Stock["timeFrame"][x+1]
			x+=1
		Stock = industry["Stocks"][1]
		x = 0
		for time in Stock["timeFrame"]:
			if x == 13:
				Stock["timeFrame"][x] = Stock["newTimeFrame"][global.currTime]
			else:
				Stock["timeFrame"][x] = Stock["timeFrame"][x+1]			
			x+=1
	makeStockScreen()
	$subTimer.start()
