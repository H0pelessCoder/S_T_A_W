extends Control

class_name IndustryTabs
static var currentIndustryPosition = 0




func drawIndustrySelectors():
	var Industries = global.Industries
	var x = 0
	for selector in get_node("IndustryTabs").get_children():
		
		var industry = Industries[Industries.keys()[currentIndustryPosition + x]]
		var pchange = percentChange(industry)
		var industryShort = industry["industryShort"]
		selector.text = industryShort + "\n" + str(snapped(pchange,0.1)) + "%"
		x+=1
	
func percentChange(industry):
		var stockAfirst = industry["Stocks"][0]["timeFrame"][0]	
		var stockAlast = industry["Stocks"][0]["timeFrame"][13]	
		var stockBfirst = industry["Stocks"][1]["timeFrame"][0]	
		var stockBlast = industry["Stocks"][1]["timeFrame"][13]		
		var change = (stockAlast + stockBlast) - (stockAfirst + stockBfirst) 
		var pchange = (change / (stockAfirst + stockBfirst)) * 100
		return pchange
		
		


func forward():
	var numindustries = global.Industries.size()
	currentIndustryPosition = min(numindustries-3, currentIndustryPosition + 3)
	drawIndustrySelectors()


func backwards():
	currentIndustryPosition = max(0, currentIndustryPosition - 3)
	drawIndustrySelectors()
