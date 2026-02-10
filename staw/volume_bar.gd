extends Control
var volume = 0

func _on_h_scroll_bar_value_changed(value):
	volume = int(value)
	$VolumeReader.text = str(volume)
