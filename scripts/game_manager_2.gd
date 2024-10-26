extends Node

var elapsed_time = 0
var loop_duration = globals.LOOP_DURATION
var cur_node
# Iterator to keep track of current node
var i = 0

@onready var audio_nodes = [$GuitarMain, $BasePerc, $Shaker, $Drums, $Bass]
var sprite_filenames = ["Guitar.svg", "Drums.svg", "Shaker.svg", "Bongos.svg", "Bass.svg"]

func _ready() -> void:
	cur_node = audio_nodes[i]
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		cur_node.play()
		i += 1
		if i < len(audio_nodes):
			cur_node = audio_nodes[i]
			change_sprite_texture(sprite_filenames[i])
		else:
			$NextLabel.text = "Todos están tocando"
			#change_sprite_texture("FirstBG.png")
			
	if Input.is_action_just_pressed("undo"):
		audio_nodes[i - 1].stop()
		if i > 0:
			i -= 1
		cur_node = audio_nodes[i]
		change_sprite_texture(sprite_filenames[i])
		$NextLabel.text = "Siguiente instrumento: "
		if $ResultLabel.visible:
			$ResultLabel.visible = false
			
func _on_submit_button_pressed() -> void:
	if cur_node != audio_nodes[len(audio_nodes) - 1]:
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

func change_sprite_texture(filename):
	var texture = load("res://sprites/" + filename)
	$Sprite.texture = texture

func _on_button_pressed() -> void:
	# Change scene to live when button is pressed
	get_tree().change_scene_to_file("res://scenes/rehearsal.tscn")

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
