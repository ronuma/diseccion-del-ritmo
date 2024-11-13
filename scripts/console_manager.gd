extends Node
@export var free_mode: bool
@export var live_mode: bool
# Rehearsal variables
var ref_time = 0
@onready var ref_player = $Guitar/Player
# TODO: Can I simplify?
# MIDI controller number mappings to their node index
const mappings = {
	24: 0,
	25: 1,
	26: 2,
	27: 3,
	28: 4
}
# Note playing mappings to node index
const on_off_maps = {
	43: 0,
	48: 1,
	50: 2,
	49: 3,
	36: 4
}

@onready var nodes = [$Guitar, $Bongos, $Drums, $Shaker,  $Bass]
func _ready():
	var new_nodes = []
	for node in nodes:
		var player = node.get_child(3)
		var slider = node.get_child(0)
		new_nodes.push_back({
			'player': player, 'slider': slider
		})
	nodes = new_nodes

func assign_new_ref():
	# Ensure ref is always a playing instrument
	for node in nodes:
		if node.player.playing:
			ref_player = node.player
			break

var previous_midi_message = null
func _input(e):
	if e is InputEventMIDI:
		if e.message != previous_midi_message:
			previous_midi_message = e.message
			# Physical slider value changed, handle signal
			if e.controller_number > 23 and e.controller_number < 29:
				var val = remap(e.controller_value, 0, 127, -40, 20)
				var node = nodes[mappings[e.controller_number]]
				node.player.volume_db = val if val > -40.0 else -INF
				node.slider.value = val
			# Note was pressed, handle on/off signal
			if e.message == 9:
				if on_off_maps.has(e.pitch):
					var node = nodes[on_off_maps[e.pitch]]
					var player = node.player
					if player.playing:
						player.stop()
					else:
						# Play from start if in free mode, else play from ref
						player.play(0 if free_mode else ref_player.get_playback_position())
					if not free_mode:
						assign_new_ref()
