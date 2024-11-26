extends Node

const loop_duration = 4.17391304347826
const pass_range = 0.1
var midi_connected = false

func _ready() -> void:
	OS.open_midi_inputs()
	if len(OS.get_connected_midi_inputs()) > 0:
		midi_connected = true
	
func _exit():
	OS.close_midi_inputs()

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


#func transform_value(val: float):
#const MAX_IMG_MODULATION = 0.7
	## Transform value to alter image's appearance
	#val = val if val < BAR_DURATION else val - BAR_DURATION
	#return abs(MAX_IMG_MODULATION - min(val, abs(val - BAR_DURATION)))
		
		#if checkScore(ref_time):
		#score += 1
		#score_label.text = "Aciertos: " + str(score)
		#bg.modulate = Color(1,1,1)
	## Time is not on the valid range so it can be used as parameter
	#else:
		#var v = transform_value(ref_time)
		#bg.modulate = Color(v,v,v)
		
# How to get the current time
#var elapsed = 0
#
#func _process(delta: float) -> void:
	#elapsed += delta
