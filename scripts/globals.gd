extends Node

const LOOP_DURATION = 4.17391304347826

func _ready() -> void:
	OS.open_midi_inputs()

func _exit():
	OS.close_midi_inputs()
