extends Node2D
@export var free_mode: bool
@onready var audio_players = [$Guitar/Player, $Shaker/Player, $Bongos/Player, $Drums/Player, $Bass/Player]

var previous_midi_message = null

# PITCH RANGES FROM 0 TO 16383

func _input(e):
	if e is InputEventMIDI:
		if e.message != previous_midi_message:
			previous_midi_message = e.message
			if e.message == 14 and e.channel >= 0 and e.channel < 5:
				var vol = map_pitch_to_volume(e.pitch)
				audio_players[e.channel].volume_db = vol if vol > -40.0 else -INF

func map_pitch_to_volume(pitch):
	# Assuming a minimum volume of -40 and a maximum of 20
	const min_volume = -40
	const max_volume = 10
	
	# Calculate the logarithmic ratio of the MIDI pitch to its maximum range
	var pitch_ratio = log(pitch + 1) / log(16384)
	
	# Map the logarithmic ratio to the volume range
	var volume = min_volume + pitch_ratio * (max_volume - min_volume)
	return volume

func _ready():
	OS.open_midi_inputs()


	
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
