extends Button

@onready
var Signature = $"../Signature"

@onready
var Return = $"../../ReturnMenuButton"

func _on_pressed():
	var x = 1
	while x < Signature.text.length()+1:
		Signature.visible_characters = x
		await get_tree().create_timer(0.2).timeout
		x+=1
	Return.visible = true
