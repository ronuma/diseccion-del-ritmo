extends Node

var ref_time = 0

@onready var ref_player = $GuitarMain
@onready var audio_data = [{
	"node": $Drums,
	"signal": "bongos"}, 
	{"node": $BasePerc,
	"signal": "drums"},
	{"node": $Shaker,
	"signal": "shaker"},
	{"node": $GuitarMain,
	"signal": "guitar"},
	{"node": $Bass,
	"signal": "ui_accept"}]
	
func _ready():
	$Drums.play()
	$BasePerc.play()
	$Shaker.play()
	$Bass.play()
	$GuitarMain.play()

func _process(_delta: float) -> void:
	for item in audio_data:
		if Input.is_action_just_pressed(item.signal):
			handle_input(item.node)
			
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
