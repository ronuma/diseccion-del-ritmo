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
		assign_new_ref(node)
	else:
		node.play(ref_player.get_playback_position())
		
func assign_new_ref(node: AudioStreamPlayer):
	# Assign a ref if node that was stopped was the current ref
	if ref_player != node:
		return
	else:
		for item in audio_data:
			if item.node.playing:
				ref_player = item.node
				break
				
func _on_button_pressed() -> void:
	# Change scene to live when button is pressed
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
	
	
	

#var score = 0
#@onready var score_label = $"../ScoreLabel"
#@onready var bg = $"../BG"
	
#var LOOP_DURATION = globals.LOOP_DURATION
#var BAR_DURATION = LOOP_DURATION / 2
#const PASS_RANGE = 0.05
#const MAX_IMG_MODULATION = 0.7
		
#func transform_value(val: float):
	## Transform value to alter image's appearance
	#val = val if val < BAR_DURATION else val - BAR_DURATION
	#return abs(MAX_IMG_MODULATION - min(val, abs(val - BAR_DURATION)))
			#
#func checkScore(val: float):
	## Check if value is valid and "in time"
	#if val <= PASS_RANGE || val >= LOOP_DURATION - PASS_RANGE || (val <= LOOP_DURATION / 2 + PASS_RANGE && val >= LOOP_DURATION / 2 - PASS_RANGE):
		#return true
	#else:
		#return false
		#if checkScore(ref_time):
		#score += 1
		#score_label.text = "Aciertos: " + str(score)
		#bg.modulate = Color(1,1,1)
	## Time is not on the valid range so it can be used as parameter
	#else:
		#var v = transform_value(ref_time)
		#bg.modulate = Color(v,v,v)
