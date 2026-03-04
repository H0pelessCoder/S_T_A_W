extends Label

var timer = "../Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = str(snapped(get_node(timer).time_left,0.1))
	
