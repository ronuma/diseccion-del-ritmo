extends Node2D

var prev_midi_message = null

func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
func _input(event):
	if event is InputEventMIDI:
		if event.message != prev_midi_message:
			_print_midi_info(event)
			prev_midi_message = event.message
		
func _print_midi_info(midi_event):
	print(midi_event)
	#print("Channel ", midi_event.channel)
	#print("Message ", midi_event.message)
	#print("Pitch ", midi_event.pitch)
	#print("Velocity ", midi_event.velocity)
	#print("Instrument ", midi_event.instrument)
	#print("Pressure ", midi_event.pressure)
	#print("Controller number: ", midi_event.controller_number)
	#print("Controller value: ", midi_event.controller_value)
