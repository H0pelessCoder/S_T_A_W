extends Button

@onready
var signingBox = $"../SigningBox"
@onready
var employerSignature = $"../EmployerSignature"

var pg = 1

func _on_pressed() -> void:
	if pg == 3:
		signingBox.visible = true
		employerSignature.visible = true
		visible = false
	get_node("../Legalese" + str(pg)).visible = false
	pg += 1
	get_node("../Legalese" + str(pg)).visible = true
