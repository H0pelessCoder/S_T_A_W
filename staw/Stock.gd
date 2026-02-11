class_name Stock
	
var timeframe = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0,
	7: 0,
	8: 0,
	9: 0,
	10: 0,
	11: 0,
	12: 0,
	13: 0,
	14: 0, 
	15: 0
}
var firstStockPoint = 0
var savedStockPoint = 0
var companyName = "Stock"
var stockShort = "STK"
var stockDescription = "Description"
func nextStockPoint(velocity, index):
	timeframe[index] = timeframe[index-1] + velocity
func resetTimeFrame():
	for time in timeframe:
		timeframe[time] = 0
func define(
	firstStockPoint,
	savedStockPoint,
	companyName,
	stockShort,
	stockDescription
	):
	firstStockPoint = firstStockPoint
	savedStockPoint = savedStockPoint
	companyName = companyName
	stockShort = stockShort
	stockDescription = stockDescription	

func printHI():
	print("HI!!!")
