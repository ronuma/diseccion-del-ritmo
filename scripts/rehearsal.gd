extends Node

@onready var ref_player = $Console/Guitar/Player
@onready var tracks = []
	
func _ready():
	for node in $Console.get_children():
		if node.name == "BG":
			continue
		tracks.push_back({
			"node": node,
			"player": node.get_child(3),
			"name": node.name
		})
		node.get_child(3).play()

func assign_new_ref(player: AudioStreamPlayer):
	# Ensure ref is always a playing instrument and not the just stopped one
	for item in tracks:
		if item.player == player:
			continue
		if item.player.playing:
			ref_player = item.player
			break

func _process(_delta: float):
	for item in tracks:
		item.node.play_from = ref_player.get_playback_position()
		if Input.is_action_just_pressed(item.name):
			assign_new_ref(item.player)

# Handle MIDI press
var prev_midi_message = null
func _input(e):
	if e is InputEventMIDI:
		if e.message != prev_midi_message:
			prev_midi_message = e.message
			if e.message == 9:
				for item in tracks:
					if item.node.note_pitch == e.pitch:
						assign_new_ref(item.player)
