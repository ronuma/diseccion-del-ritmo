extends Node2D

const signals = {
	"C": "bass",
	"B": "bongos",
	"D": "drums",
	"S": "shaker",
	"'Espacio'": "ui_accept"
}

@onready var player = $Player
@onready var label = $Label
@onready var indicator = $Indicator

var player_signal
var free_mode
var prev_midi_message = null

func _on_slider_value_changed(value: float) -> void:
	if value == -40.0:
		player.volume_db = -INF
		return
	player.volume_db = value
	
func handle_playing_indicator():
	if player.playing:
		indicator.texture = load("res://sprites/Play.png")
	else:
		indicator.texture = load("res://sprites/Mute.png")

func _ready() -> void:
	player_signal = signals[label.text]
	free_mode = get_parent().free_mode

func _process(_delta: float) -> void:
	if free_mode:
		if Input.is_action_just_pressed(player_signal):
			if player.playing:
				player.stop()
			else:
				player.play()
	
	handle_playing_indicator()
