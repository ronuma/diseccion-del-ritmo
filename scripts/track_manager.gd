extends Node2D

const signals = {
	"C": "guitar",
	"V": "bongos",
	"B": "drums",
	"N": "shaker",
	"M": "bass"
}

@onready var player = $Player
@onready var label = $Label
@onready var play_indicator = $PlayIndicator
@onready var time_indicator = $TimeIndicator

var player_signal
var free_mode
var live_mode

func _on_slider_value_changed(value: float) 	-> void:
	if value == -40.0:
		player.volume_db = -INF
		return
	player.volume_db = value
	
func handle_playing_indicator():
	play_indicator.texture = load("res://sprites/" + ("Play" if player.playing else "Mute") + ".png")

func _ready() -> void:
	player_signal = signals[label.text]
	free_mode = get_parent().free_mode
	live_mode = get_parent().live_mode
	time_indicator.visible = false

func _process(_delta: float) -> void:
	if free_mode:
		if Input.is_action_just_pressed(player_signal):
			if player.playing:
				player.stop()
			else:
				player.play()
	
	if live_mode and player.playing:
		time_indicator.visible = true
	
	handle_playing_indicator()
