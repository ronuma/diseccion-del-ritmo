extends AudioStreamPlayer



func _on_drums_slider_value_changed(value: float) -> void:
	if value == -40.0:
		volume_db = -INF
		return
	volume_db = value
