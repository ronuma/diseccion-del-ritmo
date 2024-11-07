extends Node

var ref_time = 0

@onready var ref_player = $Console/Guitar/Player
@onready var audio_data = [{
	"node": $Console/Bongos/Player,
	"signal": "bongos"}, 
	{"node": $Console/Drums/Player,
	"signal": "drums"},
	{"node": $Console/Shaker/Player,
	"signal": "shaker",
	"midi_map": 48},
	{"node": $Console/Guitar/Player,
	"signal": "ui_accept",
	"midi_map": 43},
	{"node": $Console/Bass/Player,
	"signal": "bass"}]

func handle_input(node: AudioStreamPlayer):
	if node.playing:
		node.stop()
	else:
		node.play(ref_player.get_playback_position())
	assign_new_ref(node)

func assign_new_ref(node: AudioStreamPlayer):
	# Ensure ref is always a playing instrument
	for item in audio_data:
		if item.node.playing:
			ref_player = item.node
			break

func _on_button_pressed() -> void:
	# Change scene to live when button is pressed
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _process(_delta: float) -> void:
	for item in audio_data:
		if Input.is_action_just_pressed(item.signal):
			handle_input(item.node)
