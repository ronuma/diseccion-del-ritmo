extends Node

var elapsed_time = 0
var loop_duration = globals.LOOP_DURATION
var cur_node
# Iterator to keep track of current node
var i = 0

@onready var audio_nodes = [$GuitarMain, $Bass]

func _ready() -> void:
	cur_node = audio_nodes[i]
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		cur_node.play()
		if i + 1 == len(audio_nodes):
			print("Wow. Great. Finished.")
		else:
			i += 1
			cur_node = audio_nodes[i]
	#elapsed_time += delta
	#if elapsed_time >= loop_duration and not guitar_node.playing:
		#guitar_node.play()

func _on_button_pressed() -> void:
	# Change scene to live when button is pressed
	get_tree().change_scene_to_file("res://scenes/rehearsal.tscn")
