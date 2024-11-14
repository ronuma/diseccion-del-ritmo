extends Node

@onready var tracks = []
@onready var ref_player = $Console/Guitar/Player

const pass_range = globals.pass_range

var loop_duration = globals.loop_duration
var bar_duration = loop_duration / 2
var track_to_play
var i = 0

func _ready() -> void:
	for node in $Console.get_children():
		if node.name == "BG":
			continue
		tracks.push_back({
			"node": node,
			"player": node.get_child(3),
			"name": node.name,
			"time_indicator": node.get_child(5),
		})
		node.playable = false
	track_to_play = tracks[i]
	track_to_play.node.playable = true

func check_score(val: float):
	# Check if value is valid and "in time"
	return val <= pass_range || val >= loop_duration - pass_range || (val <= loop_duration / 2 + pass_range && val >= loop_duration / 2 - pass_range)

func restart():
	i = 0
	track_to_play = tracks[i]
	track_to_play.node.playable = true
	for item in tracks:
		item.node.player.stop()
		item.node.time_indicator.visible = false

func _process(_delta: float):
	if track_to_play.player.playing:
		track_to_play.node.playable = false
		
		if i > 0:
			track_to_play.time_indicator.visible = true
			var scored = check_score(abs(ref_player.get_playback_position() - track_to_play.player.get_playback_position()))
			track_to_play.time_indicator.texture = load("res://assets/" + ("Correct" if scored else  "Wrong") + ".jpeg")
		
		i = i + 1 if i < len(tracks) - 1 else i
		track_to_play = tracks[i]
		track_to_play.node.playable = true
	else:
		track_to_play.time_indicator.visible = false
		track_to_play.node.playable = true


func _on_restart_btn_pressed() -> void:
	restart()
