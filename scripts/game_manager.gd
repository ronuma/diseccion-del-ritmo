extends Node

var elapsed_time = 0
var loop_duration = globals.LOOP_DURATION
var node_to_stop
var node_to_play

@onready var audio_nodes = [$GuitarMain, $BasePerc, $Drums, $Shaker, $Bass]
var sprite_filenames = ["Guitar.svg", "Drums.svg", "Shaker.svg", "Bongos.svg", "Bass.svg"]

var i = 0
func _ready() -> void:
	node_to_play = audio_nodes[i]
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		node_to_play.play()
		if i < len(audio_nodes):
			node_to_stop = node_to_play
			# Don't go out of the range
			i = i + 1 if i != len(audio_nodes) - 1 else i
			node_to_play = audio_nodes[i]
			update_sprite()
		else:
			$NextLabel.text = "Todos están tocando"
			#change_sprite_texture("FirstBG.png")
			
	if Input.is_action_just_pressed("undo"):
		if i == 0:
			return
		node_to_stop.stop()
		if i > 0:
			i -= 1
		node_to_play = audio_nodes[i]
		update_sprite()
		$NextLabel.text = "Siguiente instrumento: "
		if $ResultLabel.visible:
			$ResultLabel.visible = false
	
	if Input.is_action_just_pressed("restart"):
		for node in audio_nodes:
			node.stop()
		i = 0
		node_to_play = audio_nodes[i]
		node_to_stop = null
		update_sprite()
		$ResultLabel.visible = false
			
func _on_submit_button_pressed() -> void:
	if node_to_play != audio_nodes[len(audio_nodes) - 1]:
		return
	
	var ref = $GuitarMain.get_playback_position()
	var count = 0
	for node in audio_nodes:
		if node == $GuitarMain:
			continue
		if checkScore(abs(ref - node.get_playback_position())):
			count += 1
		
	$ResultLabel.visible = true
	if count == 4:
		$ResultLabel.text = "Bien hecho, los instrumentos están a tiempo"
	else:
		$ResultLabel.text = str(count) + " de 4 instrumentos entraron a tiempo con la Guitarra"

func update_sprite():
	var texture = load("res://sprites/" + sprite_filenames[i])
	$Sprite.texture = texture

func _on_button_pressed() -> void:
	# Change scene to live when button is pressed
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

var bar_duration = loop_duration / 2
const PASS_RANGE = 0.05

func checkScore(val: float):
	# Check if value is valid and "in time"
	return val <= PASS_RANGE || val >= loop_duration - PASS_RANGE || (val <= loop_duration / 2 + PASS_RANGE && val >= loop_duration / 2 - PASS_RANGE)
		
#func transform_value(val: float):
#const MAX_IMG_MODULATION = 0.7
	## Transform value to alter image's appearance
	#val = val if val < BAR_DURATION else val - BAR_DURATION
	#return abs(MAX_IMG_MODULATION - min(val, abs(val - BAR_DURATION)))
		
		#if checkScore(ref_time):
		#score += 1
		#score_label.text = "Aciertos: " + str(score)
		#bg.modulate = Color(1,1,1)
	## Time is not on the valid range so it can be used as parameter
	#else:
		#var v = transform_value(ref_time)
		#bg.modulate = Color(v,v,v)
