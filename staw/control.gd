extends Control

@export
var Industries: Dictionary

func _on_button_pressed():
	get_tree().quit() # Replace with function body.
func _ready():
	print("HI")


func _on_start_game_pressed() -> void:
	get_node("MainMenu").visible = false
	get_node("NewsMenu").visible = true
	instantiateIndustries()



func instantiateIndustries():
	#var NewStock = Stock.new()
	$"res://Stock.gd".printHI()
