extends Node

const LOOP_DURATION = 4.17391304347826

func _ready() -> void:
	OS.open_midi_inputs()

#func _print_midi_info(midi_event):
	#print(midi_event)
	#print("Channel ", midi_event.channel)
	#print("Message ", midi_event.message)
	#print("Pitch ", midi_event.pitch)
	#print("Velocity ", midi_event.velocity)
	#print("Instrument ", midi_event.instrument)
	#print("Pressure ", midi_event.pressure)
	#print("Controller number: ", midi_event.controller_number)
	#print("Controller value: ", midi_event.controller_value)

#var previous_midi_message = null
#func _input(e):
	#if e is InputEventMIDI:
		#if e.message != previous_midi_message:
			#previous_midi_message = e.message
			#_print_midi_info(e)

func _exit():
	OS.close_midi_inputs()
