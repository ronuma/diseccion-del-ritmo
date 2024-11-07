extends Node
@export var free_mode: bool
# TODO: refactor data structure to be be'er
@onready var tracks = [$Guitar, $Shaker, $Bongos, $Drums, $Bass]
var ref_time = 0
@onready var ref_player = $Guitar/Player

# MIDI controller number mappings to their node index
const mappings = {
	24: 0,
	25: 1,
	26: 2,
	27: 3,
	28: 4
}
const on_off_maps = {
	43: 0,
	48: 1,
	50: 2,
	49: 3,
	36: 4
}
var previous_midi_message = null

func _input(e):
	if e is InputEventMIDI:
		if e.message != previous_midi_message:
			previous_midi_message = e.message
			if e.controller_number > 23 and e.controller_number < 29:
				var val = remap(e.controller_value, 0, 127, -40, 20)
				var node = tracks[mappings[e.controller_number]]
				node.get_child(3).volume_db = val if val > -40.0 else -INF
				node.get_child(0).value = val
			if e.message == 9:
				if on_off_maps.has(e.pitch):
					var node = tracks[on_off_maps[e.pitch]]
					if node:
						var player = node.get_child(3)
						if player.playing:
							player.stop()
						else:
							player.play(0 if free_mode else ref_player.get_playback_position())
						if not free_mode:
							assign_new_ref()

func assign_new_ref():
	# Ensure ref is always a playing instrument
	for node in tracks:
		if node.get_child(3).playing:
			ref_player = node.get_child(3)
			break
	
func _print_midi_info(midi_event):
	print(midi_event)
	print("Channel ", midi_event.channel)
	print("Message ", midi_event.message)
	print("Pitch ", midi_event.pitch)
	print("Velocity ", midi_event.velocity)
	print("Instrument ", midi_event.instrument)
	print("Pressure ", midi_event.pressure)
	print("Controller number: ", midi_event.controller_number)
	print("Controller value: ", midi_event.controller_value)
