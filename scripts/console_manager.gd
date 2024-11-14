extends Node
# Determine Console behavior depending on mode where it is used
@export var free_mode: bool
@export var live_mode: bool

# Rehearsal variables
var rehearsal_ref_time = 0
@onready var ref_player = $Guitar/Player

# Live variables
var node_to_stop
var node_to_play
var i = 0
var loop_duration = globals.LOOP_DURATION
var bar_duration = loop_duration / 2
@onready var live_ref_node = $Guitar/Player
const PASS_RANGE = 0.05

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
		var time_indicator = node.get_child(5)
		new_nodes.push_back({
			'player': player, 'slider': slider, 'time_indicator': time_indicator
		})

		if live_mode:
			node_to_play = nodes[0].player
			player.stop()
		else:
			player.play()

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

					# LIVE MODE LOGIC
					# Play only if the instrument is the next to play
					if live_mode and node_to_play == nodes[on_off_maps[e.pitch]].player:
						node_to_play.play()

						if i < len(nodes):
							node_to_stop = node_to_play
							# Don't go out of the range
							i = i + 1 if i != len(nodes) - 1 else i
							node_to_play = nodes[i].player
						return
						
					var node = nodes[on_off_maps[e.pitch]]
					var player = node.player

					if player.playing:
						player.stop()
					else:
						# Play from start if in free mode, else play from ref
						player.play(0 if free_mode else ref_player.get_playback_position())

					if not free_mode:
						assign_new_ref()

# DEBUG
func _process(_delta):
	# LIVE MODE LOGIC
	if live_mode:
		if Input.is_action_just_pressed("ui_accept"):
			if i == 4 and node_to_play.playing:
				return
			node_to_play.play()
			if get_parent().check_score(abs(live_ref_node.get_playback_position() - node_to_play.get_playback_position())):
				nodes[i].time_indicator.texture = load("res://assets/Correct.jpeg")
			else:
				nodes[i].time_indicator.texture = load("res://assets/Wrong.jpeg")

			if i < len(nodes):
				node_to_stop = node_to_play
				# Don't go out of the range
				i = i + 1 if i != len(nodes) - 1 else i
				node_to_play = nodes[i].player
			return
