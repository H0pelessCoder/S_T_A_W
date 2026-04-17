extends Button

@onready
var Signature = $"../Signature"
@onready
var returnButton = get_meta("return")
@onready
var animating = false

func _on_pressed():

	animating = true
	self.flat = true
	var x = 1
	while x < Signature.text.length()+1:
		Signature.visible_characters = x
		await get_tree().create_timer(0.2).timeout
		x+=1
	get_node(returnButton).visible = true

func _on_mouse_entered():
	if animating == true:
		return
	self.flat = false


func _on_mouse_exited():
	if animating == true:
		return
	self.flat = true
