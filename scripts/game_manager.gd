extends Node

var score = 0
# Audio to check against when calculating bass entrance
@onready var current_ref_player = $Drums
@onready var score_label = $"../ScoreLabel"
@onready var bg = $"../BG"

const LOOP_DURATION = 4.17391304347826
const BAR_DURATION = LOOP_DURATION / 2
const PASS_RANGE = 0.05
const MAX_IMG_MODULATION = 0.7

func _ready():
	$Drums.play()
	$BasePerc.play()
	$Shaker.play()
	$Bass.play()

func _process(_delta: float) -> void:
	checkBassEntrance()
	
func checkScore(val: float):
	if val <= PASS_RANGE || val >= LOOP_DURATION - PASS_RANGE || (val <= LOOP_DURATION / 2 + PASS_RANGE && val >= LOOP_DURATION / 2 - PASS_RANGE):
		return true
	else:
		return false
		
func transform_value(val: float):
	val = val if val < BAR_DURATION else val - BAR_DURATION
	return abs(MAX_IMG_MODULATION - min(val, abs(val - BAR_DURATION)))

func checkBassEntrance():
	if Input.is_action_just_pressed("ui_accept"):
		if $Bass.playing:
			$Bass.stop()
		else:
			$Bass.play()
			var time = current_ref_player.get_playback_position()
			if checkScore(time):
				score += 1
				score_label.text = "Aciertos: " + str(score)
				bg.modulate = Color(1,1,1)

			# Time is not on the valid range so it can be used as parameter
			else:
				var v = transform_value(time)
				bg.modulate = Color(v,v,v)
	if Input.is_action_just_pressed("guitar"):
		if $GuitarMain.playing:
			$GuitarMain.stop()
		else:
			$GuitarMain.play()
			current_ref_player = $GuitarMain
	if Input.is_action_just_pressed("bongos"):
		if $Drums.playing:
			$Drums.stop()
		else:
			$Drums.play()
			current_ref_player = $Drums
	if Input.is_action_just_pressed("drums"):
		if $BasePerc.playing:
			$BasePerc.stop()
		else:
			$BasePerc.play()
			current_ref_player = $BasePerc
	if Input.is_action_just_pressed("shaker"):
		if $Shaker.playing:
			$Shaker.stop()
		else:
			$Shaker.play()
			current_ref_player = $Shaker
		var scene2 = preload("res://scenes/unmain.tscn").instantiate()
		var current_scene = preload("res://scenes/main.tscn")
		get_tree().root.add_child(scene2)
