extends Control


func _on_h_scroll_bar_value_changed(value):
	config.volume = int(value)
	$VolumeReader.text = str(config.volume)


func _on_settings_config_ready() -> void:
	_on_h_scroll_bar_value_changed(config.volume)
	$VolumeSlider.value = config.volume
