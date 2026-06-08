extends Control
signal drawStockSelectors 
var chi_modifier = 0
##THIS IS THE TRADING MENU##

#relevant because both the stock and 
#trading menu scripts are nearly identical

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
	print("Outside")
	print(pchangeA)
	var pchangeB = global.calculateStockChange(StockB)
	print("Outside")
	print(pchangeB)
	$StockAText/Title.text = StockA["stockShort"]
	$StockAText/TitleShort.text = StockA["companyName"]
	$StockBText/Title.text = StockB["stockShort"]
	$StockBText/TitleShort.text = StockB["companyName"]
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
		
		#Controls the blockers which prevent you from trading
		
		if(StockA["savedStockPoint"] != 0 || StockB["savedStockPoint"] != 0):
			$StockAText/Blocker.visible = true
			$StockBText/Blocker.visible = true
		else:
			$StockAText/Blocker.visible = false
			$StockBText/Blocker.visible = false

		emit_signal("drawStockSelectors")

#what happens after every trading interval
#interval length is determined by difficulty
func _on_sub_timer_timeout() -> void:
	global.currTime += 1
	if global.currTime > 13:
		$subTimer.stop()
		return
	#shifts every industry's stock over by one
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

#every time a trade is made the chiwave gets closer to completion
func _on_trade() -> void:
	var chiWave = $"Chi-Wave/Wave"
	var currHealth = chiWave.get_material().get_shader_parameter("health_pct")
	chiWave.get_material().set_shader_parameter("health_pct", currHealth-0.16)
	var currFreq = chiWave.get_material().get_shader_parameter("frequency")
	chiWave.get_material().set_shader_parameter("frequency", currFreq+0.6)	
	chi_modifier += 1

#resets the visual display for the chi-wave, but the rot remains
#festering
#a putrid mass of dead capital
#one day, the consequences will wash upon the world
#like atomic ash
#a brilliant destruction of that all is known and unknown
func reset_Chi_Wave() -> void:
	var chiWave = $"Chi-Wave/Wave"
	chiWave.get_material().set_shader_parameter("health_pct", 1)
	chiWave.get_material().set_shader_parameter("frequency", 4)	
	
