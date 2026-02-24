import random
def StockGeneration(first, last, variance, amount, maxVariance):
    timeframe = [first]
    increments = (last - first) / (amount-2)
    for x in range(amount-2):
        variant = random.uniform(-variance, variance)
        change = increments * variant
        next = (timeframe[x-1] + change)
        whereItShouldBe = (increments * x) + first
        if next > whereItShouldBe + maxVariance or next < whereItShouldBe - maxVariance:
            next = whereItShouldBe
        timeframe.append(int(next))
    timeframe.append(last)
    return timeframe


print(StockGeneration(711,741,6,14,30))