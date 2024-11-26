extends Node2D 

@export var play_from = 0
@export var fader_number = 0
@export var note_pitch = 0
@export var playable = true

@onready var player = $Player
@onready var label = $Label
@onready var play_indicator = $PlayIndicator
@onready var time_indicator = $TimeIndicator
@onready var slider = $Slider

var player_signal

func _on_slider_value_changed(value: float):
	if value == -40.0:
		player.volume_db = -INF
		return
	player.volume_db = value
	
func handle_playing_indicator():
	play_indicator.texture = load("res://sprites/" + ("Play" if player.playing else "Mute") + ".png")

func _ready() -> void:
	time_indicator.visible = false
	player_signal = name
	# If MIDI connected, don't show label and disable slider
	label.visible = not globals.midi_connected
	slider.editable = not globals.midi_connected

func _process(_delta: float) -> void:
	if playable:
		if Input.is_action_just_pressed(player_signal):
			if player.playing:
				player.stop()
			else:
				player.play(play_from)
	handle_playing_indicator()

# MIDI Handling
var prev_midi_msg = null
func _input(e: InputEvent):
	if e is InputEventMIDI and e.message != prev_midi_msg:
		prev_midi_msg = e.message

		# Physical slider value changed, handle signal
		if e.controller_number == fader_number:
			var val = remap(e.controller_value, 0, 127, -40, 20)
			player.volume_db = val if val > -40.0 else -INF
			slider.value = val

		if playable:
			# Note was pressed, handle on/off signal
			if e.message == 9:
				if e.pitch == note_pitch:
					if player.playing:
						player.stop()
					else:
						player.play(play_from)
