extends Node

@onready var ref_player = $Console/Guitar/Player
@onready var volume_inst_label = $InstructionLabelL
@onready var play_inst_label = $InstructionLabelR
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
	
	if not globals.midi_connected:
		volume_inst_label.text = """Cambia el volumen de los instrumentos 
									moviendo los sliders con el cursor"""
		play_inst_label.text = """Silencia/reproduce los instrumentos 
									presionando las teclas indicadas al lado
									izquierdo de cada uno"""

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
